Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbYFUVrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbYFUVrX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 17:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYFUVrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 17:47:08 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:64944 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbYFUVrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 17:47:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=JsrgFYNUmiKMVvfSy4JE9+kNFd+erCcc/MVNesaI5ccBbXaTZs7OxGwSDYIX5c0brR
         i5Qn6sQ+/E93fj5LkIdnxSXCd4pw716H4iacWlg3Dl/QtML8ol+VKtEKBVot21LEl8TQ
         8DtFbDBk/MxsOM3fwYWj7zj1DT4akNOSNFKxE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: change back to any_mapped
Date: Sat, 21 Jun 2008 14:43:39 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806211443.39735.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


agp check is using request_mem_region. and could fail if e820 reserved...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Tested-by: Kevin Winchester <kjwinchester@gmail.com>

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index e6deed1..600470d 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -324,8 +324,8 @@ void __init early_gart_iommu_check(void)
 		fix = 1;
 
 	if (gart_fix_e820 && !fix && aper_enabled) {
-		if (!e820_all_mapped(aper_base, aper_base + aper_size,
-				    E820_RESERVED)) {
+		if (e820_any_mapped(aper_base, aper_base + aper_size,
+				    E820_RAM)) {
 			/* reserve it, so we can reuse it in second kernel */
 			printk(KERN_INFO "update e820 for GART\n");
 			e820_add_region(aper_base, aper_size, E820_RESERVED);
