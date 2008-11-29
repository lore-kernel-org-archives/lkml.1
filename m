Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbYK2AL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbYK2AL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 19:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbYK2ALR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 19:11:17 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:4933 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbYK2ALP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 19:11:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=a673VNM1BHpuKtGUpH24oImmXHMctUIeeG7e8kau1qgVVOwWC6z0bVnOqBIFP0l3VB
         h1S9DpKTxhxGE344wzlTlPwc4w/k0rwGfHt1KsDAK1YT5199JcIbukmgeInX48llt3mk
         Yw930bOpAlu/KszaMXqkglMbmiVtXHKtX0QqA=
Date: Sat, 29 Nov 2008 09:11:08 +0900
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Luck, Tony" <tony.luck@intel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>,
       "dougthompson@xmission.com" <dougthompson@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-Id: <20081129091108.78fb4213.h.mitake@gmail.com>
In-Reply-To: <20081126011059.afb1e8e6.h.mitake@gmail.com>
References: <20081105222911.d76e7e1c.mitake@clustcom.com>
	<413709.12821.qm@web50106.mail.re2.yahoo.com>
	<20081106164641.ed369060.akpm@linux-foundation.org>
	<20081107152830.a42766f3.mitake@clustcom.com>
	<20081106223122.8a255211.akpm@linux-foundation.org>
	<20081107153824.0ec934e6.mitake@clustcom.com>
	<20081106231102.aab83cd4.akpm@linux-foundation.org>
	<a6b9f31a0811090710y17e956bawf20675d6678b145e@mail.gmail.com>
	<20081109112646.97c594b5.akpm@linux-foundation.org>
	<20081118121620.GB8625@linux-mips.org>
	<20081118123215.GB30509@flint.arm.linux.org.uk>
	<20081121011941.26e05a25.h.mitake@gmail.com>
	<4929ECB7.8080108@zytor.com>
	<57C9024A16AD2D4C97DC78E552063EA35C517F42@orsmsx505.amr.corp.intel.com>
	<492AEC40.5060009@zytor.com>
	<20081125115510.108fa886.h.mitake@gmail.com>
	<492B8996.2020302@zytor.com>
	<20081126003025.85f19670.h.mitake@gmail.com>
	<Pine.LNX.4.64.0811251645530.25595@anakin>
	<20081126011059.afb1e8e6.h.mitake@gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 01:10:59 +0900
Hitoshi Mitake <h.mitake@gmail.com> wrote:

> On Tue, 25 Nov 2008 16:46:18 +0100 (CET)
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> > On Wed, 26 Nov 2008, Hitoshi Mitake wrote:
> > > On Mon, 24 Nov 2008 21:13:58 -0800
> > > "H. Peter Anvin" <hpa@zytor.com> wrote:
> > > > Are you planning to add writeq() as well?
> > > 
> > > Yes, I want to add writeq().
> > > But there's a problem that
> > > I don't have a plan to use writeq() now, so I can't test writeq() soon.
> > > 
> > > How is this? I think it isn't bad. I want to hear your opinion.
> > > 
> > > static inline void writeq(__u64 val, volatile void __iomem *addr)
> > > {
> > > 	writel((unsigned int)val, addr);
> > > 	writel((unsigned int)(val >> 32), addr+1);
> >                                                ^
> > 					       4
> > 
> > > }
> > 
> 
> Thanks, I missed about void pointer...
> 

I rewrote the patch. I think newest version is good enough.
Could you please review this?

description of this patch
Adding implementation of readq/writeq to x86_32,
and adding config value to x86 architecture to determine existence of readq/writeq

Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
---
 arch/x86/Kconfig          |    4 ++++
 arch/x86/include/asm/io.h |   24 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ac22bb7..10bd84c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -11,9 +11,13 @@ config 64BIT
 
 config X86_32
 	def_bool !64BIT
+	select ARCH_HAS_READQ
+	select ARCH_HAS_WRITEQ
 
 config X86_64
 	def_bool 64BIT
+	select ARCH_HAS_READQ
+	select ARCH_HAS_WRITEQ
 
 ### Arch settings
 config X86
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index ac2abc8..ac15d0e 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -4,6 +4,7 @@
 #define ARCH_HAS_IOREMAP_WC
 
 #include <linux/compiler.h>
+#include <asm-generic/int-ll64.h>
 
 #define build_mmio_read(name, size, type, reg, barrier) \
 static inline type name(const volatile void __iomem *addr) \
@@ -57,6 +58,29 @@ build_mmio_write(__writeq, "q", unsigned long, "r", )
 /* Let people know we have them */
 #define readq readq
 #define writeq writeq
+
+#else  /* CONFIG_X86_32 from here */
+
+static inline __u64 readq(const volatile void __iomem *addr)
+{
+	const volatile u32 __iomem *p = addr;
+	u32 l, h;
+
+	l = readl(p);
+	h = readl(p+1);
+
+	return l + ((u64)h << 32);
+}
+
+static inline void writeq(__u64 val, volatile void __iomem *addr)
+{
+	writel((unsigned int)val, addr);
+	writel((unsigned int)(val >> 32), addr+4);
+}
+
+#define readq readq
+#define writeq writeq
+
 #endif
 
 extern int iommu_bio_merge;
-- 
1.5.6.5

