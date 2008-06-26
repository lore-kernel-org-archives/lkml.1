Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbYFZBGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbYFZBGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756916AbYFZBBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:01:52 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:23642 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626AbYFZBBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:01:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=rQDISEnK++ztYktnfZQkZsTORQZposApkxFdHy56L9tzxY67RZSMp3b0j4o6HWSXvn
         0GGsqT8xQQC4kGdDY/rKHfLdHD58FE8aaYSZ5Js7wBwkNYRBiCWHE8b4OtfwWgU5RqIB
         lO760TTW2JvdCJewu0dxViReOKBlrq+yfLVCw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 14/16] x86: make x86_find_smp_config depends on 64 bit too
Date: Wed, 25 Jun 2008 17:59:41 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com>
In-Reply-To: <200806251748.06743.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251759.41670.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/Kconfig        |    1 -
 arch/x86/kernel/setup.c |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -236,7 +236,6 @@ config SMP
 config X86_FIND_SMP_CONFIG
 	def_bool y
 	depends on X86_MPPARSE || X86_VOYAGER || X86_VISWS
-	depends on X86_32
 
 if ACPI
 config X86_MPPARSE
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -713,8 +713,7 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	acpi_reserve_bootmem();
 #endif
-#if defined(CONFIG_X86_FIND_SMP_CONFIG) && defined(CONFIG_X86_32) || \
-    defined(CONFIG_X86_MPPARSE) && defined(CONFIG_X86_64)
+#ifdef CONFIG_X86_FIND_SMP_CONFIG
 	/*
 	 * Find and reserve possible boot-time SMP configuration:
 	 */
