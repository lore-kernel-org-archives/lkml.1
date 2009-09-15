Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbZIOQYC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbZIOQYC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:24:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbZIOQYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:24:01 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:51159 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbZIOQYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:24:00 -0400
Subject: Re: [PATCH] arm: remove unused code in delay.S
From: Steve Chen <schen@mvista.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Felipe Contreras <felipe.contreras@gmail.com>,
       Jamie Lokier <jamie@shareable.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <200909151541.08852.marek.vasut@gmail.com>
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com>
	 <20090915103739.GA19519@elf.ucw.cz> <1253017761.3273.117.camel@linux-1lbu>
	 <200909151541.08852.marek.vasut@gmail.com>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 11:30:10 -0500
Message-Id: <1253032210.3273.128.camel@linux-1lbu>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 15:41 +0200, Marek Vasut wrote:
> > -#if 0
> > +#if CONFIG_OLD_CPU_DELAY
> 
> ifdef please
> 
I assume this a vote in favor of considering this patch as an
alternative :)  The updated patch is below.  Since I'm only summarizing
the e-mail thread and put them into a patch (which is a less time
consuming process than continue reading and deleting e-mails on this
thread), contributors can add signed off before submitting to Russel.

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
+	bool "Accurate delays for older CPU"
+	def_bool n
+	help
+	  Enable if observing longer than expected delays and need more
+	  accurate delays on older CPUs.
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


