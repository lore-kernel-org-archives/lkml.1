Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbZAHPEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbZAHPEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 10:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZAHPEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 10:04:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZAHPEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:04:35 -0500
Date: Thu, 8 Jan 2009 10:04:30 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Kyle McMartin <kyle@infradead.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Subject: Re: [PATCH] mtrr: fix types used in userspace exported header
Message-ID: <20090108150430.GA15684@bombadil.infradead.org>
References: <20090108150126.GA9483@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108150126.GA9483@bombadil.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Commit 932d27a7913fc6b3c64c6e6082628b0a1561dec9 exported some mtrr
structures without using the exportable __uX types, causing userspace
build failures.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

---

Missed the u8 typedef below the struct.

diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index cb988aa..14080d2 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -58,15 +58,15 @@ struct mtrr_gentry {
 #endif /* !__i386__ */
 
 struct mtrr_var_range {
-	u32 base_lo;
-	u32 base_hi;
-	u32 mask_lo;
-	u32 mask_hi;
+	__u32 base_lo;
+	__u32 base_hi;
+	__u32 mask_lo;
+	__u32 mask_hi;
 };
 
 /* In the Intel processor's MTRR interface, the MTRR type is always held in
    an 8 bit field: */
-typedef u8 mtrr_type;
+typedef __u8 mtrr_type;
 
 #define MTRR_NUM_FIXED_RANGES 88
 #define MTRR_MAX_VAR_RANGES 256
