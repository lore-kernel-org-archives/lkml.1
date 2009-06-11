Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbZFKTCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbZFKTCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758834AbZFKTBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:01:48 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:37499 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759520AbZFKTBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:01:46 -0400
Date: Thu, 11 Jun 2009 14:26:02 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Larry.Finger@lwfinger.net
Subject: Re: [PATCH 2/2] SLUB: Disable debugging if it increases the minimum
 page order
In-Reply-To: <20090611180422.GJ7302@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0906111422360.11973@gentwo.org>
References: <Pine.LNX.4.64.0906111143490.6132@melkki.cs.Helsinki.FI> <alpine.DEB.1.10.0906110941520.29827@gentwo.org> <1244728824.17483.51.camel@penberg-laptop> <alpine.DEB.1.10.0906111021340.29827@gentwo.org> <1244733119.17483.56.camel@penberg-laptop>
 <alpine.DEB.1.10.0906111118350.14020@gentwo.org> <1244734086.17483.59.camel@penberg-laptop> <alpine.DEB.1.10.0906111140080.24376@gentwo.org> <20090611180422.GJ7302@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009, Mel Gorman wrote:

> "With SLUB_DEBUG, enable debug on all caches unless the increased meta-data
> would force the minimum order up on order due to object sizes being near or
> equal the PAGE_SIZE. If SLUB_DEBUG must be enabled, specify slub_debug=A for
> 'All caches enable debug regardless'"

Hmmm... No SLUB_DEBUG just compiles the code in for debugging. Does not
enable anything.

But we could make SLUB_DEBUG_ON enable debugging except on those slabs
where the order increases (for which it does a printk saying that the
debugging was disabled) and then have a slub_debug=A option that
overrides the order check. Generally if you know that you have memory
corruption you would want to boot with slub_debug=A. If you just want
continuous checks then SLUB_DEBUG_ON would do the trick.

