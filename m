Return-Path: <linux-kernel-owner+w=401wt.eu-S1762170AbXKNSeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762170AbXKNSeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbXKNSd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:33:56 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43324 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752759AbXKNSdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:33:55 -0500
Date: Wed, 14 Nov 2007 10:33:54 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: nickpiggin@yahoo.com.au, herbert@gondor.apana.org.au,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2: Network commit causes SLUB performance regression
 with tbench
In-Reply-To: <20071114.041008.146131045.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711141028390.12531@schroedinger.engr.sgi.com>
References: <20071114.031022.183117678.davem@davemloft.net>
 <20071114114844.GA13927@gondor.apana.org.au> <200711141102.11477.nickpiggin@yahoo.com.au>
 <20071114.041008.146131045.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007, David Miller wrote:

> > Still interested to know why SLAB didn't see the same thing...
> 
> Yes, I wonder why too.  I bet objects just got packed differently.

The objects are packed tightly in SLUB and SLUB can allocate smaller 
objects (minimum is 8 SLAB mininum is 32).

On free a SLUB object goes directly back to the slab where it came from. 
We have no queues in SLUB so we use the first word of the object as a 
freepointer. In SLAB the objects first go onto queues and then are drained 
later into the slab. On free in SLAB there is usually no need to touch the 
object itself. The object pointer is simply moved onto the queue (works 
well in SMP, in NUMA we have overhead identifying the queue and 
overhead due to the number of queues needed).

