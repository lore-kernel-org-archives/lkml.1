Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbYD2Q6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbYD2Q6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYD2Q6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:58:37 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59349 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751149AbYD2Q6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:58:36 -0400
Date: Tue, 29 Apr 2008 09:58:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: sancelot@free.fr, linux-kernel@vger.kernel.org
Subject: Re: detecting kernel mem leak
In-Reply-To: <84144f020804290546h666983aci77fbb08eb507e777@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804290956360.10847@schroedinger.engr.sgi.com>
References: <1209462094.4816ed4e93977@imp.free.fr>
 <84144f020804290546h666983aci77fbb08eb507e777@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008, Pekka Enberg wrote:

> or use a tool such as slabtop to see where the memory is going. If the
> memory is being leaked in the kmalloc caches, you can use
> CONFIG_DEBUG_SLAB_LEAK which part of the kernel is doing all those
> allocations (not really suitable for production machines).

For slub: Just enable debugging and then do a cat on 
/sys/kernel/slab/<cachename>/allocs or frees to see where memory is 
allocated or freed.

 
> Christoph, I suppose there's some option to
> Documentation/vm/slabinfo.c that provides similar output to
> CONFIG_DEBUG_SLAB_LEAK for SLUB?

If you run a report on a slabcache with f.e.

	slabinfo kmalloc-2048

and debugging is enabled then all functions that allocate and free objects 
in kmalloc-2048 are listed.

Just doing
	slabinfo

list all caches with the number of objects allocated.

