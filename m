Return-Path: <linux-kernel-owner+w=401wt.eu-S932655AbZKFWXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655AbZKFWXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932598AbZKFWXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:23 -0500
Received: from kroah.org ([198.145.64.141]:57027 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512AbZKFWXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:20 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:48 2009
Message-Id: <20091106221548.134452197@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Manuel Lauss <manuel.lauss@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Subject: [68/99] mips: fix build of vmlinux.lds
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=mips-fix-build-of-vmlinux.lds.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Manuel Lauss <manuel.lauss@gmail.com>

commit d71789b6fa37c21ce5eb588d279f57904a62e7e2 upstream.

Commit 51b563fc93c8cb5bff1d67a0a71c374e4a4ea049 ("arm, cris, mips,
sparc, powerpc, um, xtensa: fix build with bash 4.0") removed a few
CPPFLAGS with vital include paths necessary to build vmlinux.lds
on MIPS, and moved the calculation of the 'jiffies' symbol
directly to vmlinux.lds.S but forgot to change make ifdef/... to
cpp macros.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
[sam: moved assignment of CPPFLAGS arch/mips/kernel/Makefile]
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/mips/kernel/Makefile      |    2 ++
 arch/mips/kernel/vmlinux.lds.S |   12 ++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the Linux/MIPS kernel.
 #
 
+CPPFLAGS_vmlinux.lds := $(KBUILD_CFLAGS)
+
 extra-y		:= head.o init_task.o vmlinux.lds
 
 obj-y		+= cpu-probe.o branch.o entry.o genex.o irq.o process.o \
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -10,15 +10,15 @@ PHDRS {
 	note PT_NOTE FLAGS(4);	/* R__ */
 }
 
-ifdef CONFIG_32BIT
-	ifdef CONFIG_CPU_LITTLE_ENDIAN
+#ifdef CONFIG_32BIT
+	#ifdef CONFIG_CPU_LITTLE_ENDIAN
 		jiffies  = jiffies_64;
-	else
+	#else
 		jiffies  = jiffies_64 + 4;
-	endif
-else
+	#endif
+#else
 	jiffies  = jiffies_64;
-endif
+#endif
 
 SECTIONS
 {


