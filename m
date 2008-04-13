Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbYDMUyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbYDMUyA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 16:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYDMUxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 16:53:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751828AbYDMUxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:53:53 -0400
Date: Sun, 13 Apr 2008 13:53:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, clameter@sgi.com, penberg@cs.helsinki.fi
Subject: Re: 2.6.25-rc8-mm2: IP: [<ffffffff802868f9>] __kmalloc+0x69/0x110
Message-Id: <20080413135344.60dc2e05.akpm@linux-foundation.org>
In-Reply-To: <20080413204422.GA5136@martell.zuzino.mipt.ru>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
	<20080413204422.GA5136@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 00:44:22 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Grrr, I was hunting for oopses in dup_fd and near that were plaguing one
> box here for far too long, and hit below.
> 
> What happened if freshly booted box (probably not all init scripts finished),
> X already started. ssh from another box and reboot from session.
> 
> 
> (gdb) p __kmalloc
> $1 = {void *(size_t, gfp_t)} 0xffffffff80286890 <__kmalloc>
> (gdb) l *(0xffffffff80286890 + 0x69)
> 0xffffffff802868f9 is in __kmalloc (mm/slub.c:1663).
> 1658
> 1659                    object = __slab_alloc(s, gfpflags, node, addr, c);
> 1660
> 1661            else {
> 1662                    object = c->freelist;
> 1663      ===>          c->freelist = object[c->offset];   <===
> 1664                    stat(c, ALLOC_FASTPATH);
> 1665            }
> 1666            local_irq_restore(flags);

Yes, I don't think the sub changes are ready for prime-time.

There is a fix in
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm2/hot-fixes
but it won't help this crash.
