Return-Path: <linux-kernel-owner+w=401wt.eu-S932829AbZJLRxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbZJLRxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932667AbZJLRxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:53:04 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:51805
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575AbZJLRxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:53:03 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Mark A. Miller" <mark@mirell.org>
Subject: Re: [PATCH] Expose BOOT_RAW Kconfig Symbol
Date: Mon, 12 Oct 2009 12:51:51 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <31014a580910120227j3023d3f0t947f6feeba427487@mail.gmail.com> <31014a580910120231p58c4f4ebi122c9232a7c288f3@mail.gmail.com>
In-Reply-To: <31014a580910120231p58c4f4ebi122c9232a7c288f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910121251.51590.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Miller <mark@mirell.org>

This exposes the CONFIG_BOOT_RAW symbol in Kconfig. This is needed on
certain Broadcom chipsets running CFE in order to load the kernel.

Signed-off-by: Mark Miller <mark@mirell.org>
Acked-by: Rob Landley <rob@landley.net>
---

 arch/mips/Kconfig |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index f4af967..023604d 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -670,9 +670,6 @@ config ARC
 config ARCH_MAY_HAVE_PC_FDC
 	bool
 
-config BOOT_RAW
-	bool
-
 config CEVT_BCM1480
 	bool
 
@@ -1887,6 +1884,18 @@ config SECCOMP
 
 	  If unsure, say Y. Only embedded should say N here.
 
+config BOOT_RAW
+	bool "Enable the kernel to be executed from the load address"
+	default n
+	help
+	 Allow the kernel to be executed from the load address for
+	 bootloaders which cannot read the ELF format. This places
+	 a jump to start_kernel at the load address.
+
+	 If unsure, say N.
+
+
+
 endmenu
 
 config LOCKDEP_SUPPORT


-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
