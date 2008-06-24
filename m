Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbYFXCzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbYFXCzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 22:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYFXCyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 22:54:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:33417 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbYFXCyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 22:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=AmyqBcLdeXHj5TsH/Kr8vaCufiGYf79GuG0vCK1FEMsZ2W2XReTC8SW9EC2bgyiKME
         d8B8C17c7wNFfaEh/dkLAhWpY6nYnYlcxDwjWLtsO8Mcx0yCXDDJc74JO4FdX0DQAdUh
         xik1UNImcvdGlzQGuSZmycBR4Tfc52QSrLVqo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: setup_arch 32bit move efi check later
Date: Mon, 23 Jun 2008 19:53:33 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806231951.10898.yhlu.kernel@gmail.com> <200806231952.04756.yhlu.kernel@gmail.com> <200806231952.44320.yhlu.kernel@gmail.com>
In-Reply-To: <200806231952.44320.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231953.33437.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup_32.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -337,14 +337,6 @@ void __init setup_arch(char **cmdline_p)
 	early_ioremap_init();
 	reserve_setup_data();
 
-#ifdef CONFIG_EFI
-	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     "EL32", 4)) {
-		efi_enabled = 1;
-		efi_reserve_early();
-	}
-#endif
-
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
 	screen_info = boot_params.screen_info;
 	edid_info = boot_params.edid_info;
@@ -364,10 +356,17 @@ void __init setup_arch(char **cmdline_p)
 	rd_prompt = ((boot_params.hdr.ram_size & RAMDISK_PROMPT_FLAG) != 0);
 	rd_doload = ((boot_params.hdr.ram_size & RAMDISK_LOAD_FLAG) != 0);
 #endif
+#ifdef CONFIG_EFI
+	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
+		     "EL32", 4)) {
+		efi_enabled = 1;
+		efi_reserve_early();
+	}
+#endif
+
 	ARCH_SETUP
 
 	setup_memory_map();
-
 	copy_edd();
 
 	if (!boot_params.hdr.root_flags)
