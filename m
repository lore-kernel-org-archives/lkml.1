Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbYJXLiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbYJXLiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbYJXLiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:38:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51012 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYJXLiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:38:05 -0400
Date: Fri, 24 Oct 2008 13:37:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, lethal@linux-sh.org,
       paulus@samba.org, benh@kernel.crashing.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: [GIT PULL] s390 updates for 2.6.28-rc1
Message-ID: <20081024113724.GA21375@elte.hu>
References: <20081024105049.GC4620@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024105049.GC4620@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> The s390 vdso preparation patch "arch_setup_additional_pages argument" 
> touches other architectures (x86, sh and powerpc):
> 
> arch_setup_additional_pages currently gets two arguments, the binary 
> format descripton and an indication if the process uses an executable 
> stack or not. The second argument is not used by anybody, it could be 
> removed without replacement.

hm, this is the first time i've seen this change, and it looks a bit 
weird:

--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -325,7 +325,7 @@ struct linux_binprm;

 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
-                                      int executable_stack);
+                                      int uses_interp);

why didnt you just add a new uses_interp argument?

executable_stack is passed in to potentially enable architectures to be 
aware of how conservative/legacy the address-space of the binary is - 
whether to randomize the vdso, etc. exec-shield used to take advantage 
of that.

But there seems to be no in-tree use of that (and if one arises it can 
just add back that parameter), and i dont want to stand in the way of 
your pull request either, so for the x86 bits:

 Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
