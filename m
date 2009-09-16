Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbZIPIT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbZIPIT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZIPITz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:19:55 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:20308 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZIPITy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:19:54 -0400
Subject: Re: [PATCH] arm: remove unused code in delay.S
From: Steve Chen <schen@mvista.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Jamie Lokier <jamie@shareable.org>, linux-kernel@vger.kernel.org,
       Marek Vasut <marek.vasut@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <m33a6nddvd.fsf@intrepid.localdomain>
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com>
	 <20090915103739.GA19519@elf.ucw.cz> <1253017761.3273.117.camel@linux-1lbu>
	 <200909151541.08852.marek.vasut@gmail.com>
	 <1253032210.3273.128.camel@linux-1lbu>
	 <94a0d4530909151158y489a96e3x63ff932c713822b0@mail.gmail.com>
	 <1253043875.3273.131.camel@linux-1lbu>
	 <m3k4zzdimy.fsf@intrepid.localdomain>
	 <1253053609.3273.139.camel@linux-1lbu>
	 <m33a6nddvd.fsf@intrepid.localdomain>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 03:26:06 -0500
Message-Id: <1253089566.3273.152.camel@linux-1lbu>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 00:47 +0200, Krzysztof Halasa wrote:
> Steve Chen <schen@mvista.com> writes:
> 
> > If I know for sure that these are the processors that need that block of
> > code, your suggestion makes perfect sense.  Unfortunately, I don't know.
> 
> Then I wouldn't write "Accurate delays". "Different", maybe.
> "Accurate", we don't know.
You are right.  "Accurate delays" isn't appropriate.  Probably want
something along the lines of "try this and see if helps".

> 
> > My primary goals are
> >
> > 1.  Put a stop to this thread (so far I have failed miserably)
> > 2.  Document that block of code.
> > 3.  If it makes someone's life easier.. it would be a bonus.
> 
> Uncertain comments don't make life easier. Just write what's certain,
> or nothing if nothing is.
Makes sense.  Based on both yours and Marek's inputs, I changed the
wording.  The patch is below.

Document #if 0 code block in delay.S and make it selectable for compile.

Signed-off-by: Steve Chen <schen@mvista.com>

---

 arch/arm/Kconfig     |    8 ++++++++
 arch/arm/lib/delay.S |    2 +-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index aef63c8..ca8d535 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -813,6 +813,14 @@ config ARM_ERRATA_460075
 	  ACTLR register. Note that setting specific bits in the ACTLR
register
 	  may not be available in non-secure mode.
 
+config OLD_CPU_DELAY
+	depends on CPU_32v3 || CPU_32v4 || CPU_32v4T
+	bool "Accurate delays for some older CPUs"
+	def_bool n
+	help
+	  Try enable this if observing longer than expected delays and need
+	  more accuracy.  May cause instability in some CPUs.
+
 endmenu
 
 source "arch/arm/common/Kconfig"
diff --git a/arch/arm/lib/delay.S b/arch/arm/lib/delay.S
index 8d6a876..67e679b 100644
--- a/arch/arm/lib/delay.S
+++ b/arch/arm/lib/delay.S
@@ -42,7 +42,7 @@ ENTRY(__const_udelay)				@ 0 <= r0 <= 0x7fffff06
 @ Delay routine
 ENTRY(__delay)
 		subs	r0, r0, #1
-#if 0
+#ifdef CONFIG_OLD_CPU_DELAY
 		movls	pc, lr
 		subs	r0, r0, #1
 		movls	pc, lr


