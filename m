Return-Path: <linux-kernel-owner+w=401wt.eu-S932892AbXF2EWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892AbXF2EWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 00:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbXF2EWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 00:22:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40495 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750752AbXF2EWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 00:22:23 -0400
Date: Thu, 28 Jun 2007 21:22:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: hugh@veritas.com, James.Bottomley@steeleye.com, rmk+lkml@arm.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter gather
 lists
In-Reply-To: <20070628.211013.74747656.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0706282119330.11676@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706282047160.10035@schroedinger.engr.sgi.com>
 <20070628.211013.74747656.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, David Miller wrote:

> > Still a better solution would be to not use the slab allocator at all for 
> > the objects that are used to send commands to the devices. These are not 
> > permanent and grabbing a page from the pcp lists and putting it back is 
> > likely as fast as performing a kmalloc.
> 
> Jens Axboe wants to get references to the page structs behind
> kmalloc() allocated pages in his networking splice work.

You can get such a reference and then the slab page will be in limbo if 
all objects are freed until that reference is given up. The reference 
method is also use by kmem_cache_vacate() (but that is slab internal).

> We could make a special allocator in the networking that carves
> chunks out of pages but I'm sure you'll find that about as stupid
> and wasteful as I do :-)

Well then I guess this containment patch is as good as we can get.
It makes sure that things do not get out of hand.

