Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbYHNNcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbYHNNcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYHNNcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:32:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60809 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbYHNNcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:32:02 -0400
Date: Thu, 14 Aug 2008 15:31:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] irq: sparse irqs, fix
Message-ID: <20080814133134.GA4411@elte.hu>
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com> <20080814132638.GA18743@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080814132638.GA18743@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 547c9dd238f4412622fb6a2622d81c35c0a9fb85 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 14 Aug 2008 15:32:59 +0200
Subject: [PATCH] irq: sparse irqs, fix
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fix:

drivers/pci/intel-iommu.c: In function ‘dmar_set_interrupt':
drivers/pci/intel-iommu.c:918: error: too few arguments to function ‘create_irq'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/pci/intel-iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 389fdd6..be10d86 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -915,7 +915,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
 {
 	int irq, ret;
 
-	irq = create_irq();
+	irq = create_irq(0);
 	if (!irq) {
 		printk(KERN_ERR "IOMMU: no free vectors\n");
 		return -EINVAL;
