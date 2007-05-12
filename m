Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbXELUKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbXELUKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 16:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbXELUKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 16:10:00 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:45483 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998AbXELUJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 16:09:59 -0400
Date: Sat, 12 May 2007 22:10:07 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: Reboot PATCH (ACPI related)
Message-ID: <20070512201006.GA3569@ics.muni.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@fi.muni.cz
X-Muni-Envelope-To: linux-kernel@vger.kernel.org
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sat, 12 May 2007 22:09:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello,

why the attached patch is still not included in mainline kernel? It fixes boot
problems after suspend to RAM.

-- 
Luká¹ Hejtmánek

--0F1p//8PRICkK4MW
Content-Type: text/x-diff; charset=iso-8859-2
Content-Disposition: attachment; filename="reboot.patch"

--- arch/i386/kernel/reboot.c.old	2006-06-18 03:49:35.000000000 +0200
+++ arch/i386/kernel/reboot.c	2006-07-01 17:29:23.000000000 +0200
@@ -31,6 +31,12 @@
 #ifdef CONFIG_SMP
 static int reboot_cpu = -1;
 #endif
+#ifdef CONFIG_ACPI
+extern u32 acpi_disable(void);
+#else
+static u32 acpi_disable(void){};
+#endif
+
 static int __init reboot_setup(char *str)
 {
 	while(1) {
@@ -322,6 +328,7 @@
 
 void machine_emergency_restart(void)
 {
+	acpi_disable();
 	if (!reboot_thru_bios) {
 		if (efi_enabled) {
 			efi.reset_system(EFI_RESET_COLD, EFI_SUCCESS, 0, NULL);

--0F1p//8PRICkK4MW--
