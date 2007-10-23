Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbXJWUJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbXJWUJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbXJWUJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:09:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41644 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752062AbXJWUJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:09:31 -0400
Date: Tue, 23 Oct 2007 13:09:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: SLUB 0:1 SLAB (OOM during massive parallel kernel builds)
In-Reply-To: <84144f020710231304h6cba8626na4ab4bec0acda7a0@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710231305050.20095@schroedinger.engr.sgi.com>
References: <20071023181615.GA10377@martell.zuzino.mipt.ru> 
 <Pine.LNX.4.64.0710231227590.19626@schroedinger.engr.sgi.com>
 <84144f020710231304h6cba8626na4ab4bec0acda7a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007, Pekka Enberg wrote:

> On 10/23/07, Christoph Lameter <clameter@sgi.com> wrote:
> > Not sure what this is. Maybe the slowing SLUB solves the race.
> 
> What kind of race are you thinking of? What I initially thought was
> that the problem is that SLUB messes up some other VM heuristics due
> to different object sizes, not holding on to empty slabs, and/or page
> allocator pass-through. I guess only object size is affected by
> debugging, though?

The number of objects per page is reduced by enabling full debugging. That 
triggers a potential of more order 1 allocations but we are failing at 
order 0 allocs. slub_debug=F does not increase object size with debugging 
information but keeps things as they are while doing as much verification 
of slab integrity as possible.

One--potentially far fetched theory--is that the difference in alloc 
performance may trigger a race. But I guess it is more likely that we will 
find something wrong with the gfp flags (that I recategorized for 2.6.24).


