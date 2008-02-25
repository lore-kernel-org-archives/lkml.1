Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbYBYGfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbYBYGfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 01:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbYBYGfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 01:35:09 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:59739 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbYBYGfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 01:35:07 -0500
Date: Sun, 24 Feb 2008 22:43:49 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86: vSMP selection in config
In-reply-to: <200802242136.28744.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kiran@scalemp.com, shai@scalemp.com, Glauber Costa <gcosta@redhat.com>
Message-id: <200802242243.49576.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802210258.45011.yinghai.lu@sun.com>
 <200802241832.37850.yinghai.lu@sun.com> <200802242136.28744.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


find out vSMP setting is going away in config after make oldconfig

vSMP need to PARAVIRT and PCI.
so move PARAVIRT out of if PARAVIRT_GUEST, and make vSMP select PCI instead of
depends on PCI

after patch vSMP could stick there.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -330,8 +330,9 @@ config X86_RDC321X
 
 config X86_VSMP
 	bool "Support for ScaleMP vSMP"
-	depends on X86_64 && PCI
+	depends on X86_64
 	select PARAVIRT
+	select PCI
 	help
 	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
 	  supposed to run on these EM64T-based machines.  Only choose this option
@@ -376,6 +377,8 @@ config VMI
 
 source "arch/x86/lguest/Kconfig"
 
+endif
+
 config PARAVIRT
 	bool "Enable paravirtualization code"
 	depends on !(X86_VISWS || X86_VOYAGER)
@@ -385,8 +388,6 @@ config PARAVIRT
 	  over full virtualization.  However, when run without a hypervisor
 	  the kernel is theoretically slower and slightly larger.
 
-endif
-
 config ACPI_SRAT
 	def_bool y
 	depends on X86_32 && ACPI && NUMA && (X86_SUMMIT || X86_GENERICARCH)
