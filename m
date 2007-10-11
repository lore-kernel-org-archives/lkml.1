Return-Path: <linux-kernel-owner+w=401wt.eu-S1757832AbXJKJ2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbXJKJ2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 05:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbXJKJ2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 05:28:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:46481 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756019AbXJKJ2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 05:28:03 -0400
Date: Thu, 11 Oct 2007 11:27:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] i386 and x86_64: randomize brk()
In-Reply-To: <20071011015553.cdf05128.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710111123560.20620@jikos.suse.cz>
References: <Pine.LNX.4.64.0709111416390.7343@jikos.suse.cz>
 <20071011011800.0c051792.akpm@linux-foundation.org>
 <20071011015553.cdf05128.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007, Andrew Morton wrote:

> And on s390
> In file included from arch/s390/kernel/binfmt_elf32.c:202:
> arch/s390/kernel/../../../fs/binfmt_elf.c: In function 'load_elf_binary':
> arch/s390/kernel/../../../fs/binfmt_elf.c:1088: error: implicit declaration of function 'arch_randomize_brk'

This should be fixed trivially in the very same way as for x86_64, i.e. 
something like

diff --git a/arch/s390/kernel/binfmt_elf32.c b/arch/s390/kernel/binfmt_elf32.c
index f1e40ca..4b5432d 100644
--- a/arch/s390/kernel/binfmt_elf32.c
+++ b/arch/s390/kernel/binfmt_elf32.c
@@ -199,5 +199,6 @@ cputime_to_compat_timeval(const cputime_t cputime, struct compat_timeval *value)
 	value->tv_sec = cputime / 1000000;
 }
 
+extern void arch_randomize_brk(void);
 #include "../../../fs/binfmt_elf.c"


right? Maybe this would be needed for other architectures too :( I will 
check this. I'd really like the patch go in, so that we have really full 
randomization finally.

> I'll drop the patch. Really we should fix the elf mess before we try and 
> change it any more.

I agree that it is a total mess. We'd need someone brave enough to rewrite 
this crap :/

Thanks,

-- 
Jiri Kosina
SUSE Labs
