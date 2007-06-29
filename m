Return-Path: <linux-kernel-owner+w=401wt.eu-S1751366AbXF2HAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbXF2HAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 03:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbXF2HAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 03:00:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46773 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751455AbXF2HAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 03:00:40 -0400
Date: Fri, 29 Jun 2007 00:00:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: hugh@veritas.com, James.Bottomley@steeleye.com, rmk+lkml@arm.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter gather
 lists
In-Reply-To: <20070628.220606.112621271.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0706282357540.12146@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706282119330.11676@schroedinger.engr.sgi.com>
 <20070628.212825.78710369.davem@davemloft.net>
 <Pine.LNX.4.64.0706282128570.11739@schroedinger.engr.sgi.com>
 <20070628.220606.112621271.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, David Miller wrote:

> Really, it would be great if we could treat kmalloc() objects
> just like real pages.  Everything wants to do I/O on pages
> but sometimes (like the networking) you have a kmalloc
> chunk which is technically just a part of a page.
> 
> The fact that there is no easy way to make this work is
> frustrating :-)

There is easy way: Allocate a page and just use the first N bytes. You can 
specify the bytes to be used when putting the memory onto the scatter 
gather list. This wastes memory but it works. You have real refcounting 
since you got a real page.

How frequent are these objects?

