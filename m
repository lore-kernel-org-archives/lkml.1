Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYLDP7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYLDP7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:59:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYLDP6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:58:50 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:46372 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbYLDP6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:58:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=hLkTrVGc1tCZJ+f0K/tEd9g+VYPW/FfPTiif7Jd3XUuU8NAdqvt73YpX6qDxvYVsim
         qM4D7mrF2NhR8N+3NcRdU6+zvXeNUhYIxP8+aS/kawKx1fChhR8Ao/4bhu8lZJMiwJd7
         vd70xpyBAIh07uJ0aov8/i8QtZ/XvG+AokKq8=
Date: Fri, 5 Dec 2008 00:58:41 +0900
From: Hitoshi Mitake <h.mitake@gmail.com>
To: "Hitoshi Mitake" <h.mitake@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Sam Ravnborg" <sam@ravnborg.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Ralf Baechle" <ralf@linux-mips.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Doug Thompson" <norsk5@yahoo.com>, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-Id: <20081205005841.1ee1dc71.h.mitake@gmail.com>
In-Reply-To: <a6b9f31a0812011558o373edbd3r9690efe539d43ca0@mail.gmail.com>
References: <20081129192610.716a2d57.h.mitake@gmail.com>
	<20081129222449.e341f028.h.mitake@gmail.com>
	<20081129180144.GA15533@uranus.ravnborg.org>
	<20081130171604.dc3c8715.h.mitake@gmail.com>
	<20081130083700.GA31644@elte.hu>
	<20081130092407.GA10802@elte.hu>
	<20081201002056.d9f9204c.h.mitake@gmail.com>
	<20081130161504.GA25627@elte.hu>
	<a6b9f31a0812010551h28c0841fxa2a26af4645df64@mail.gmail.com>
	<20081201135922.GA30068@elte.hu>
	<a6b9f31a0812011558o373edbd3r9690efe539d43ca0@mail.gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2008 08:58:19 +0900
"Hitoshi Mitake" <h.mitake@gmail.com> wrote:

> On Mon, Dec 1, 2008 at 22:59, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Hitoshi Mitake <h.mitake@gmail.com> wrote:
> >
> >> On Mon, Dec 1, 2008 at 01:15, Ingo Molnar <mingo@elte.hu> wrote:
> >> >
> >> > * Hitoshi Mitake <h.mitake@gmail.com> wrote:
> >> >
> >> >> On Sun, 30 Nov 2008 10:24:07 +0100
> >> >> Ingo Molnar <mingo@elte.hu> wrote:
> >> >>
> >> >> >
> >> >> > the 32-bit build broke promptly - readq/writeq is a family of APIs that
> >> >> > has to be either fully provided or not provided at all. The fix is below.
> >> >>
> >> >> Thanks for your fix and adding!
> >> >> When will this patch be added to mainline?
> >> >> I want to rewrite x38_edac.c to adapt new APIs.
> >> >
> >> > v2.6.29 at the earliest - if there are no regressions. A number of
> >> > drivers use these APIs and usage is a bit messy - so bugs could be
> >> > triggered, etc.
> >> >
> >> Thanks. What is URL of your repository?
> >> I want to look your tree and test it.
> >
> > you can pick up tip/master via:
> >
> >  http://people.redhat.com/mingo/tip.git/README
> >
> 

I build your tree with allmodconfig, but there's no compile error.

And I wrote a patch to add HAVE_READQ and HAVE_WRITEQ to all architecutres without x86.

Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
---
 arch/alpha/Kconfig   |    2 ++
 arch/ia64/Kconfig    |    2 ++
 arch/mips/Kconfig    |    2 ++
 arch/parisc/Kconfig  |    2 ++
 arch/powerpc/Kconfig |    2 ++
 arch/sh/Kconfig      |    2 ++
 arch/sparc64/Kconfig |    2 ++
 7 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 6110197..4355170 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -8,6 +8,8 @@ config ALPHA
 	select HAVE_AOUT
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_READQ
+	select HAVE_WRITEQ
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 6bd91ed..833bfdd 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -24,6 +24,8 @@ config IA64
 	select HAVE_DMA_ATTRS
 	select HAVE_KVM
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_READQ
+	select HAVE_WRITEQ
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index f4af967..cf4f046 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -7,6 +7,8 @@ config MIPS
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB
+	select HAVE_READQ
+	select HAVE_WRITEQ
 
 mainmenu "Linux/MIPS Kernel Configuration"
 
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 644a70b..4eef1f0 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -11,6 +11,8 @@ config PARISC
 	select HAVE_OPROFILE
 	select RTC_CLASS
 	select RTC_DRV_PARISC
+	select HAVE_READQ
+	select HAVE_WRITEQ
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
 	  in many of their workstations & servers (HP9000 700 and 800 series,
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 525c13a..9e1701f 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -121,6 +121,8 @@ config PPC
 	select HAVE_DMA_ATTRS if PPC64
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_OPROFILE
+	select HAVE_READQ
+	select HAVE_WRITEQ
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 80119b3..410e1fe 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -13,6 +13,8 @@ config SUPERH
 	select HAVE_OPROFILE
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_IOREMAP_PROT if MMU
+	select HAVE_READQ
+	select HAVE_WRITEQ
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 3b96e70..b92409f 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -24,6 +24,8 @@ config SPARC64
 	select RTC_DRV_BQ4802
 	select RTC_DRV_SUN4V
 	select RTC_DRV_STARFIRE
+	select HAVE_READQ
+	select HAVE_WRITEQ
 
 config GENERIC_TIME
 	bool
-- 
1.5.6.5

