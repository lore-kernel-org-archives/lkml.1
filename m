Return-Path: <linux-kernel-owner+w=401wt.eu-S1030188AbXBJL6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030188AbXBJL6n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933390AbXBJL6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:58:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946829AbXBJL6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:58:09 -0500
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       joerg@hydrops.han.de, dsd@gentoo.org, paulus@samba.org,
       benh@kernel.crashing.org, lethal@linux-sh.org
Subject: Re: [PATCH] Make aout executables work again
References: <Pine.LNX.4.64.0702092100540.3984@localhost.localdomain>
From: Andi Kleen <ak@suse.de>
Date: 10 Feb 2007 13:58:13 +0100
In-Reply-To: <Pine.LNX.4.64.0702092100540.3984@localhost.localdomain>
Message-ID: <p73y7n6goey.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Parag Warudkar <parag.warudkar@gmail.com> writes:

> This a reworked, replacement version of
> x86-fix-vdso-mapping-for-aout-executables-* series of patches in -mm.
> 
> 1) Define arch_setup_additional_pages() as weak in linux/interp.h
> 2) Include linux/interp.h in appropriate places
> 3) Conditionally call arch_setup_additional_pages() from binfmt_*.c if
> the arch defines it
> 4) EXPORT_SYMBOL_GPL(arch_setup_additional_pages) for all x86{64},
> powerpc, sh - binfmt_aout can be built as module
> 5) Get rid of ARCH_HAS_SETUP_ADDITIONAL_PAGES from various places
> 6) For x86_64 - define and export arch_setup_additional_pages as a
> wrapper over syscall32_setup_pages, call it from ia32_aout.c
> 
> Fully tested on x86. (Compile, boot and run the aout binary at
> http://ftp.funet.fi/pub/Linux/bin/as86.tar.Z). Other arches - changes
> are minimal but still I'll appreciate if someone tests them.

I already fixed this in a different way -- just use the stack
trampoline on a.out

Can you double check

ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/aout-no-vdso

works for you?

-Andi
