Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZCDC4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZCDC4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 21:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZCDCz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 21:55:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54564 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbZCDCz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 21:55:57 -0500
Message-ID: <49ADEDA3.1030406@redhat.com>
Date: Tue, 03 Mar 2009 21:55:31 -0500
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       ying.huang@intel.com
Subject: Re: [PATCH] fix DMI for EFI
References: <49A9F597.4010601@redhat.com> <86802c440902281856h1dc950e7me8568cd5dca59da9@mail.gmail.com>
In-Reply-To: <86802c440902281856h1dc950e7me8568cd5dca59da9@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090206060604080908070501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090206060604080908070501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

New patch. Its easier I think to just move efi_init() earlier. Seems 
less risky and less drawbacks.

Signed-off-by: Brian Maly <bmaly@redhat>


 setup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)



--------------090206060604080908070501
Content-Type: text/x-patch;
 name="fix-DMI-for-EFI-2.6.29.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-DMI-for-EFI-2.6.29.patch"

--- a/arch/x86/kernel/setup.c	2009-03-03 21:24:53.000000000 -0500
+++ b/arch/x86/kernel/setup.c	2009-03-03 21:26:00.000000000 -0500
@@ -770,6 +770,9 @@ void __init setup_arch(char **cmdline_p)
 
 	finish_e820_parsing();
 
+	if (efi_enabled)
+		efi_init();
+
 	dmi_scan_machine();
 
 	dmi_check_system(bad_bios_dmi_table);
@@ -789,8 +792,6 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
-	if (efi_enabled)
-		efi_init();
 
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {

--------------090206060604080908070501--
