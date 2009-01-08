Return-Path: <linux-kernel-owner+w=401wt.eu-S1760352AbZAHPBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760352AbZAHPBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 10:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbZAHPB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 10:01:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51618 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbZAHPB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:01:27 -0500
Date: Thu, 8 Jan 2009 10:01:26 -0500
From: Kyle McMartin <kyle@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: [PATCH] mtrr: fix types used in userspace exported header
Message-ID: <20090108150126.GA9483@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Commit 932d27a7913fc6b3c64c6e6082628b0a1561dec9 exported some mtrr
structures without using the exportable __uX types, causing userspace
build failures.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index cb988aa..1b0d528 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -58,10 +58,10 @@ struct mtrr_gentry {
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
