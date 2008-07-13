Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbYGMVd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbYGMVd1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 17:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbYGMVdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 17:33:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:30421 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297AbYGMVdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:33:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=nnQuaGl+YB+0pt7VR7Ze7+V4h5qyXgA5B5EQqzg8J8P7hK/1ijO/1ibo0ZBUu5vvgW
         i0xrlLQBCZ27ZcFxRoBLtyYPHv3g/XJCOYn1CBd8JsuaVaLLPNzE2NMp6jdTEMgZ35+2
         aXNVslJBFcbV0H6a8SQ9ynRJr6mhv/m8JCvPY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: max_low_pfn_mapped fix #4
Date: Sun, 13 Jul 2008 14:29:41 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com> <200807121432.45759.yhlu.kernel@gmail.com>
In-Reply-To: <200807121432.45759.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807131429.42193.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	only add direct mapping for aperture

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/pci-gart_64.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/pci-gart_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-gart_64.c
+++ linux-2.6/arch/x86/kernel/pci-gart_64.c
@@ -680,11 +680,8 @@ static __init int init_k8_gatt(struct ag
 	/* need to map that range */
 	end_pfn = (aper_base>>PAGE_SHIFT) + (aper_size>>PAGE_SHIFT);
 	if (end_pfn > max_low_pfn_mapped) {
-		start_pfn = max_low_pfn_mapped;
-		max_low_pfn_mapped = init_memory_mapping(start_pfn<<PAGE_SHIFT,
-							 end_pfn<<PAGE_SHIFT);
-		if (max_pfn_mapped < max_low_pfn_mapped)
-			max_pfn_mapped = max_low_pfn_mapped;
+		start_pfn = (aper_base>>PAGE_SHIFT);
+		init_memory_mapping(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
 	}
 	return 0;
 
