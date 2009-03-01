Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbZCACkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbZCACkl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 21:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZCACkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 21:40:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38876 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbZCACkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 21:40:31 -0500
Message-ID: <49A9F597.4010601@redhat.com>
Date: Sat, 28 Feb 2009 21:40:23 -0500
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix DMI for EFI
Content-Type: multipart/mixed;
 boundary="------------030408090802080504010208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030408090802080504010208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Updated patch. Might be good for someone who runs VMware to verify things still work though.
Looks right now I think.


Brian


>This init_hypervisor comment looks important, no? Possibly it needs
>to be moved after the new placement? Doesn't look like the probe_roms
>will be an issue.

>regards, Kyle


--------------030408090802080504010208
Content-Type: text/x-patch;
 name="fix-DMI-for-EFI-2.6.29.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-DMI-for-EFI-2.6.29.patch"

--- a/arch/x86/kernel/setup.c	2009-02-08 15:37:27.000000000 -0500
+++ b/arch/x86/kernel/setup.c	2009-03-01 02:27:45.000000000 -0500
@@ -770,16 +770,6 @@ void __init setup_arch(char **cmdline_p)
 
 	finish_e820_parsing();
 
-	dmi_scan_machine();
-
-	dmi_check_system(bad_bios_dmi_table);
-
-	/*
-	 * VMware detection requires dmi to be available, so this
-	 * needs to be done after dmi_scan_machine, for the BP.
-	 */
-	init_hypervisor(&boot_cpu_data);
-
 #ifdef CONFIG_X86_32
 	probe_roms();
 #endif
@@ -792,6 +782,16 @@ void __init setup_arch(char **cmdline_p)
 	if (efi_enabled)
 		efi_init();
 
+	dmi_scan_machine();
+	
+	dmi_check_system(bad_bios_dmi_table);
+
+	/*
+	 * VMware detection requires dmi to be available, so this
+	 * needs to be done after dmi_scan_machine, for the BP.
+	 */
+	init_hypervisor(&boot_cpu_data);
+
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
 		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,

--------------030408090802080504010208--
