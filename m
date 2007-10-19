Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbXJSWh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbXJSWh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbXJSWhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:37:50 -0400
Received: from styx.suse.cz ([82.119.242.94]:41519 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752891AbXJSWht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:37:49 -0400
Date: Sat, 20 Oct 2007 00:10:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] i386 and x86_64: randomize brk()
In-Reply-To: <20071011015553.cdf05128.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710200005350.12935@jikos.suse.cz>
References: <Pine.LNX.4.64.0709111416390.7343@jikos.suse.cz>
 <20071011011800.0c051792.akpm@linux-foundation.org>
 <20071011015553.cdf05128.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007, Andrew Morton wrote:

> > Anyway, it breaks on ia64:
> And on s390
> In file included from arch/s390/kernel/binfmt_elf32.c:202:
> arch/s390/kernel/../../../fs/binfmt_elf.c: In function 'load_elf_binary':
> arch/s390/kernel/../../../fs/binfmt_elf.c:1088: error: implicit declaration of function 'arch_randomize_brk'
> I'll drop the patch.
> Really we should fix the elf mess before we try and change it any more.

... back to this a week old thread about already dropped patch.

I am thinking about going back to the original idea of just simply 
defining ARCH_HAS_RANDOMIZE_BRK and not caring for the ELF crap any more 
for now. This way the patch is as small as possible, and doesn't interfere 
with the ELF cross-arch craziness at all.

Here I posted such version of the patch: 
http://lkml.org/lkml/2007/8/22/254 and here you asked me to put empty 
stubs into elf.h, which turned out to be too headache for some archs: 
http://lkml.org/lkml/2007/8/22/492

Does going back to the original ARCH_HAS_RANDOMIZE_BRK sound acceptable 
now, before the ELF stuff gets completely rewritten one day?

Thanks,

-- 
Jiri Kosina
