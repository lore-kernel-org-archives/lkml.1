Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZKJL2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZKJL2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbZKJL2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:28:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32946 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbZKJL2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:28:05 -0500
Date: Tue, 10 Nov 2009 12:27:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, wmw2@infradead.org,
       joerg.roedel@amd.com, muli@il.ibm.com
Subject: Re: [PATCH -v2 7/9] swiotlb: add swiotlb_free function
Message-ID: <20091110112750.GB24190@elte.hu>
References: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1257849980-22640-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257849980-22640-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


this patch needed the fix below, for the !CONFIG_SWIOTLB case.

	Ingo

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 6b70068..eb9bdb4 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -87,6 +87,11 @@ swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
 extern int
 swiotlb_dma_supported(struct device *hwdev, u64 mask);
 
+#ifdef CONFIG_SWIOTLB
 extern void __init swiotlb_free(void);
+#else
+static inline void swiotlb_free(void) { }
+#endif
+
 extern void swiotlb_print_info(void);
 #endif /* __LINUX_SWIOTLB_H */

