Return-Path: <linux-kernel-owner+w=401wt.eu-S1760943AbYGRXRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943AbYGRXRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbYGRXQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:16:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:2831 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbYGRXQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:16:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=rBj5tbs4Qvi03QbbcHsB2f1M4qFMcjAAhrdfWomaC+lkECTly2S9tq/hlpBARlIVa3
         ngGP+DIUccp82lddooQGZlOL0g6MN9QovwDi/dtc2FsYsmLGnIMGiWF9QdCUlpu7/9QB
         Gy97/hITZIcEuGhEEhUasFctgUFNq3o6Lf3DA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: add target bootmem range that in early_res_to_bootmem printout
Date: Fri, 18 Jul 2008 16:16:23 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807181616.23384.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 28c2918..d360fc8 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -877,7 +877,8 @@ void __init early_res_to_bootmem(u64 start, u64 end)
 	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++)
 		count++;
 
-	printk(KERN_INFO "(%d early reservations) ==> bootmem\n", count);
+	printk(KERN_INFO "(%d early reservations) ==> bootmem [%010llx - %010llx]\n",
+			 count, start, end);
 	for (i = 0; i < count; i++) {
 		struct early_res *r = &early_res[i];
 		printk(KERN_INFO "  #%d [%010llx - %010llx] %16s", i,
