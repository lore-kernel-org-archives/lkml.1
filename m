Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYFXCzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYFXCzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 22:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbYFXCyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 22:54:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:9836 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbYFXCyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 22:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=I5Pkol4I/ro7Cx742m2UTzFoo6HIa+xtdZLHYqVmhoyvMlkVZFYhVZt28acC3a2kKm
         JkwwNqiZ9mhBltNVmvYCfM2Z/1v8LGFZowUsyCodQdx4AbcO3d9ofW/RWyNFPOHsQycT
         SoJbl0feMRkT/sHkLJb45P9X+FKS2eK+BdOkU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: setup_arch 64bit move efi_init calling early
Date: Mon, 23 Jun 2008 19:52:04 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806231951.10898.yhlu.kernel@gmail.com>
In-Reply-To: <200806231951.10898.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231952.04756.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup_32.c |   32 ++++++++++++++++++--------------
 arch/x86/kernel/setup_64.c |   14 +++++++-------
 2 files changed, 25 insertions(+), 21 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -260,6 +260,9 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
+	if (efi_enabled)
+		efi_init();
+
 	early_gart_iommu_check();
 
 	e820_register_active_regions(0, 0, -1UL);
@@ -286,8 +289,6 @@ void __init setup_arch(char **cmdline_p)
 	check_efer();
 
 	max_pfn_mapped = init_memory_mapping(0, (end_pfn << PAGE_SHIFT));
-	if (efi_enabled)
-		efi_init();
 
 	vsmp_init();
 
