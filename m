Return-Path: <linux-kernel-owner+w=401wt.eu-S1762489AbYARPsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762489AbYARPsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760086AbYARPs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:48:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32878 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759401AbYARPs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:48:27 -0500
Date: Fri, 18 Jan 2008 16:48:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes for v2.6.24
Message-ID: <20080118154809.GA18248@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

two fixes: a "make mrproper" bug and a new cpuid for oprofile, both 
build/boot tested.

	Ingo

------------------>
Arjan van de Ven (1):
      x86: add support for the latest Intel processors to Oprofile

Michael Opdenacker (1):
      x86: fix make mrproper

 Makefile                    |    2 +-
 arch/x86/oprofile/nmi_int.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 713f685..a7aa374 100644
--- a/Makefile
+++ b/Makefile
@@ -1088,7 +1088,7 @@ CLEAN_FILES +=	vmlinux System.map \
                 .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
 
 # Directories & files removed with 'make mrproper'
-MRPROPER_DIRS  += include/config include2 usr/include
+MRPROPER_DIRS  += include/config include2 usr/include arch/i386 arch/x86_64
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 2d0eeac..944bbcd 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -380,7 +380,7 @@ static int __init ppro_init(char ** cpu_type)
 
 	if (cpu_model == 14)
 		*cpu_type = "i386/core";
-	else if (cpu_model == 15)
+	else if (cpu_model == 15 || cpu_model == 23)
 		*cpu_type = "i386/core_2";
 	else if (cpu_model > 0xd)
 		return 0;
