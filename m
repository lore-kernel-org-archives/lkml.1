Return-Path: <linux-kernel-owner+w=401wt.eu-S1759054AbYBKSrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054AbYBKSrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbYBKSr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:47:29 -0500
Received: from twin.jikos.cz ([213.151.79.26]:38952 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbYBKSr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:47:29 -0500
Date: Mon, 11 Feb 2008 19:47:22 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Abel Bernabeu <abelbg@m2grp.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch] Elf loader crash while zero-filling .bss
In-Reply-To: <15577be70802111032l6ea6d2fagba2da4462c739d66@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802111944220.7699@twin.jikos.cz>
References: <15577be70802111027s59bc16f7q7c0be42cc44f9ad7@mail.gmail.com>
 <15577be70802111032l6ea6d2fagba2da4462c739d66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Abel Bernabeu wrote:

> > set_brk(start, end) allocs just page aligned regions (by "colapsing"
> > both extremes to the start of the page in which they lay)... That
> > means than even if both pointers are not equal there are still some
> > chances that set_brk has allocated no space at all because
> > ELF_PAGEALIGN(elf_bss) != ELF_PAGEALIGN(elf_brk).
> Sorry this was an errata in my comment:  no space is allocated at all
> because ELF_PAGEALIGN(elf_bss) == ELF_PAGEALIGN(elf_brk)

I also don't fully understand the "colapsing" part ... ELF_PAGEALIGN() 
really aligns the address to the nearest page boundary at the higher 
address ... so I don't understand the comment about colapsing to the start 
of the page that contains the address, it's seems to me that the real 
behavior is quite the opposite.

-- 
Jiri Kosina
SUSE Labs

