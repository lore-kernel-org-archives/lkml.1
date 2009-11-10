Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbZKJLMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbZKJLMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZKJLMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:12:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34629 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbZKJLMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:12:30 -0500
Date: Tue, 10 Nov 2009 12:12:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, wmw2@infradead.org,
       joerg.roedel@amd.com, muli@il.ibm.com
Subject: Re: [PATCH -v2 5/9] intel-iommu: convert detect_intel_iommu to use
 iommu_init hook
Message-ID: <20091110111219.GA32342@elte.hu>
References: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1257849980-22640-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257849980-22640-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> This changes detect_intel_iommu() to set intel_iommu_init() to
> iommu_init hook if detect_intel_iommu() finds the IOMMU.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/x86/kernel/pci-dma.c |    2 --
>  drivers/pci/dmar.c        |    4 ++++
>  include/linux/dmar.h      |   10 ----------
>  3 files changed, 4 insertions(+), 12 deletions(-)

FYI, the !CONFIG_DMAR case needed the fix below. (Wrt. the -ENODEV: it 
doesnt matter right now as we dont check the result of ->iommu_init(), 
but i kept it consistent with device initialization principles.)

	Ingo

diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index d814d7d..df0cfb3 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -219,5 +219,8 @@ struct dmar_atsr_unit {
 };
 
 extern int intel_iommu_init(void);
-#endif
+#else /* !CONFIG_DMAR: */
+static inline int intel_iommu_init(void) { return -ENODEV; }
+#endif /* CONFIG_DMAR */
+
 #endif /* __DMAR_H__ */
