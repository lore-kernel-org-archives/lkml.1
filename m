Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbXIEMqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbXIEMqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 08:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbXIEMqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 08:46:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42068 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137AbXIEMqN (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 08:46:13 -0400
Date: Wed, 5 Sep 2007 05:45:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: pomac@vapor.com
Cc: Linux-kernel@vger.kernel.org
Subject: Re: Cache not being reclaimed?
Message-Id: <20070905054501.9c59dc56.akpm@linux-foundation.org>
In-Reply-To: <1188955687.8365.5.camel@localhost>
References: <1188955687.8365.5.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 05 Sep 2007 03:28:07 +0200 Ian Kumlien <pomac@vapor.com> wrote:
> Hi, 
> 
> I have just had a quite unexpected 'low memory situation'...
> 
> This is a AMD64 machine with 2 gig memory, running 64 bit userland.
> 
> Kernel: 2.6.23-rc3-git10, updating to -rc5-* as soon as i can.
> I'm using SLUB:s
> 
> 
> To me, this looks odd... I thought that any cached memory would be
> reclamed but it was always full.
> 
> Ideas?
> 
> One example from dmesg:
> swapper: page allocation failure. order:1, mode:0x4020
> 
> Call Trace:
>  <IRQ>  [<ffffffff8026c7ef>] __alloc_pages+0x30f/0x330
>  [<ffffffff8028a0a1>] __slab_alloc+0x141/0x590
>  [<ffffffff805a5937>] __netdev_alloc_skb+0x17/0x40
>  [<ffffffff805a5937>] __netdev_alloc_skb+0x17/0x40
>  [<ffffffff8028b470>] __kmalloc_track_caller+0xa0/0xc0
>  [<ffffffff805a4b3f>] __alloc_skb+0x6f/0x150
>  [<ffffffff805a5937>] __netdev_alloc_skb+0x17/0x40
>  [<ffffffff88010945>] :sky2:sky2_rx_alloc+0x25/0xf0
>  [<ffffffff88013b0c>] :sky2:sky2_poll+0x6dc/0xcf0
>  [<ffffffff805e5f60>] tcp_delack_timer+0x0/0x210
>  [<ffffffff805ac38a>] net_rx_action+0x8a/0x140
>  [<ffffffff80242ac9>] __do_softirq+0x69/0xe0
>  [<ffffffff8020cd9c>] call_softirq+0x1c/0x30
>  [<ffffffff8020eb75>] do_softirq+0x35/0x90
>  [<ffffffff8020ede0>] do_IRQ+0x80/0x100
>  [<ffffffff8020ad00>] default_idle+0x0/0x40
>  [<ffffffff8020c121>] ret_from_intr+0x0/0xa
>  <EOI>  [<ffffffff8020ad29>] default_idle+0x29/0x40
>  [<ffffffff8020ade1>] cpu_idle+0xa1/0xf0
> 

An order-1 GFP_ATOMIC allocation can fail, and networking should recover
from it.

If this is happening a lot then someting might have been broken.  Do you
have reason to believe that the frequency of this happening has inreased?
