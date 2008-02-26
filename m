Return-Path: <linux-kernel-owner+w=401wt.eu-S1761959AbYBZAU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959AbYBZAU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755946AbYBZAUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:20:19 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:36703 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870AbYBZAUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:20:17 -0500
Date: Mon, 25 Feb 2008 16:28:45 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86: PARAVIRT needed by PARAVIRT_GUEST or X86_VSMP
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Message-id: <200802251628.46111.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so it could be off automatically when PARAVIRT_GUEST or X86_VSMP is not there

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 92b53ec..5bbb385 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -379,6 +379,8 @@ source "arch/x86/lguest/Kconfig"
 
 endif
 
+if PARAVIRT_GUEST || X86_VSMP
+
 config PARAVIRT
 	bool "Enable paravirtualization code"
 	depends on !(X86_VISWS || X86_VOYAGER)
@@ -388,6 +390,8 @@ config PARAVIRT
 	  over full virtualization.  However, when run without a hypervisor
 	  the kernel is theoretically slower and slightly larger.
 
+endif
+
 config ACPI_SRAT
 	def_bool y
 	depends on X86_32 && ACPI && NUMA && (X86_SUMMIT || X86_GENERICARCH)
