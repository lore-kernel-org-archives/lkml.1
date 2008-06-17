Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbYFQL3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbYFQL3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 07:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbYFQL25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 07:28:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51639 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbYFQL2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 07:28:54 -0400
Subject: Re: architectures with ARCH_SUPPORTS_AOUT but no binfmt_aout
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, dhowells@redhat.com, andi@firstfloor.org,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>, ysato@users.sourceforge.jp,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org, kyle@mcmartin.ca,
       matthew@wil.cx, grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20080617101112.GE20169@cs181133002.pp.htv.fi>
References: <1213565555.26255.522.camel@pmac.infradead.org>
	 <1213604973-7073-1-git-send-email-jacmet@sunsite.dk>
	 <1213617663.26255.708.camel@pmac.infradead.org>
	 <20080616121727.GB10854@cs181133002.pp.htv.fi>
	 <1213619214.26255.721.camel@pmac.infradead.org>
	 <20080617084235.GA20169@cs181133002.pp.htv.fi>
	 <1213696004.26255.960.camel@pmac.infradead.org>
	 <20080617101112.GE20169@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Tue, 17 Jun 2008 12:28:33 +0100
Message-Id: <1213702113.26255.996.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-17 at 13:11 +0300, Adrian Bunk wrote:
> The pattern for this stuff is to provide a HAVE_AOUT kconfig variable 
> that gets select'ed by these architectures.

http://git.infradead.org/users/dwmw2/aout-2.6.git?a=commitdiff;h=a5db5179

Subject: [PATCH] Introduce HAVE_AOUT symbol to remove hard-coded arch list for BINFMT_AOUT

HAVE_AOUT doesn't quite do the same thing as the recently removed
ARCH_SUPPORTS_AOUT config option. That was set even on platforms where
binfmt_aout isn't supported, although it's not entirely clear why.

So it's best just to introduce a new symbol, handled consistently with
other similar HAVE_xxx symbols; with a simple 'select' the arch Kconfig.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 arch/alpha/Kconfig |    1 +
 arch/arm/Kconfig   |    1 +
 arch/m68k/Kconfig  |    1 +
 arch/x86/Kconfig   |    1 +
 fs/Kconfig.binfmt  |    5 ++++-
 5 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 207196e..f80e548 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -7,6 +7,7 @@ config ALPHA
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_AOUT
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 8fd3ab3..2be8bd7 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -14,6 +14,7 @@ config ARM
 	select HAVE_OPROFILE
 	select HAVE_KPROBES if (!XIP_KERNEL)
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
+	select HAVE_AOUT
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index bfb6395..83c4338 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -6,6 +6,7 @@ config M68K
 	bool
 	default y
 	select HAVE_IDE
+	select HAVE_AOUT
 
 config MMU
 	bool
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8fdaa70..bd066ae 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -25,6 +25,7 @@ config X86
 	select HAVE_KRETPROBES
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
+	select HAVE_AOUT if X86_32
 
 config ARCH_DEFCONFIG
 	string
diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 0999d5c..5592e08 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -59,9 +59,12 @@ config BINFMT_SHARED_FLAT
 	help
 	  Support FLAT shared libraries
 
+config HAVE_AOUT
+       def_bool n
+
 config BINFMT_AOUT
 	tristate "Kernel support for a.out and ECOFF binaries"
-	depends on (X86_32 || ALPHA || ARM || M68K)
+	depends on HAVE_AOUT
 	---help---
 	  A.out (Assembler.OUTput) is a set of formats for libraries and
 	  executables used in the earliest versions of UNIX.  Linux used
-- 
1.5.5.1


-- 
dwmw2

