Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbXIEIOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbXIEIOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 04:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbXIEIO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 04:14:28 -0400
Received: from bay0-omc1-s23.bay0.hotmail.com ([65.54.246.95]:3225 "EHLO
	bay0-omc1-s23.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753154AbXIEIO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 04:14:27 -0400
Message-ID: <BAY103-DAV12D93B7C4F6214C867EE70B2CB0@phx.gbl>
X-Originating-IP: [85.36.106.198]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Cc: <linux-kernel@vger.kernel.org>, "David Chinner" <dgc@sgi.com>,
       <xfs@oss.sgi.com>, <mel@skynet.ie>,
       "Marco Berizzi" <pupilla@hotmail.com>
References: <BAY103-DAV11CCE8C757E221217A0176B2EA0@phx.gbl> <Pine.LNX.4.64.0708030937280.17307@schroedinger.engr.sgi.com> <BAY103-DAV602D6B6D39BC875BBCB69B2CA0@phx.gbl> <Pine.LNX.4.64.0709040952570.5768@schroedinger.engr.sgi.com>
Subject: Re: kernel BUG at mm/slab.c:2980 (was Re: [<c019c63f>] xfs_bmap_search_multi_extents+0x6f/0xe0)
Date: Wed, 5 Sep 2007 10:12:56 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 05 Sep 2007 08:14:26.0404 (UTC) FILETIME=[C6464240:01C7EF94]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Christoph Lameter" wrote:


> On Tue, 4 Sep 2007, Marco Berizzi wrote:
>
> > After a week uptime I got this error. I hope it
> > will be useful for you.
>
> Yes indeed but this is a different type of failure. Looks like a
higher
> allocation failure in the networking code. Someone created objects
that
> required an order 2 allocations that failed.
>
> > SLUB: Genslabs=22, HWalign=32, Order=0-1, MinObjects=4, CPUs=1,
Nodes=1
>
> Slub is restricted to order 0 and 1 allocs.
>
> >   PREFETCH window: e5c00000-e7cfffff
> > NET: Registered protocol family 2
> > IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
> > TCP established hash table entries: 8192 (order: 4, 65536 bytes)
> > TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
>
> Hmmmm.
>
> > eth2:  setting full-duplex.
> > swapper: page allocation failure. order:2, mode:0x4020
> >  [<c013b21d>] __alloc_pages+0x1ed/0x2e0
> >  [<c014ee3b>] allocate_slab+0x4b/0x90
> >  [<c014eef2>] new_slab+0x32/0x150
> >  [<c014f47b>] __slab_alloc+0xcb/0x120
> >  [<c014f429>] __slab_alloc+0x79/0x120
> >  [<c02b0183>] tcp_collapse+0x113/0x3b0
>
> tcp_collapse? This is due to a network configuration that required an
> order 2 kmalloc block. Jumbo frames?

I don't use jumbo frames. Hardware is
very old (celeron with 3com 3c905).


