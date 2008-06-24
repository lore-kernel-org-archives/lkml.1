Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbYFXCz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbYFXCz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 22:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbYFXCy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 22:54:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:33417 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbYFXCyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 22:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=C4fzMWRZDAOGZUv47aKwuu7t01ee9UOHULeCEyMwNjJFJwP5Q30LEGyrY4Q2/+2thg
         71DHwJpKXC1k+MeKHUr5s9MUc1jH43oHJ2TKtmSdnbmmOZB5ZsdMMW9CAG2XyNNtE5Va
         PXrkmHdBpTYs1HqcaTjS90Jnt1RZqPPkmCETw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: setup_arch 32bit move command line copying early
Date: Mon, 23 Jun 2008 19:54:23 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806231951.10898.yhlu.kernel@gmail.com> <200806231952.44320.yhlu.kernel@gmail.com> <200806231953.33437.yhlu.kernel@gmail.com>
In-Reply-To: <200806231953.33437.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231954.23694.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup_32.c |   32 ++++++++++++++++++--------------
 arch/x86/kernel/setup_64.c |   14 +++++++-------
 2 files changed, 25 insertions(+), 21 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -383,6 +383,9 @@ void __init setup_arch(char **cmdline_p)
 	bss_resource.start = virt_to_phys(&__bss_start);
 	bss_resource.end = virt_to_phys(&__bss_stop)-1;
 
+	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
+	*cmdline_p = command_line;
+
 	parse_setup_data();
 
 	parse_early_param();
@@ -408,9 +411,6 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
-	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
-	*cmdline_p = command_line;
-
 	if (efi_enabled)
 		efi_init();
 
