Return-Path: <linux-kernel-owner+w=401wt.eu-S1759934AbXIZWe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934AbXIZWe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760313AbXIZWeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:34:03 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:35880 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995AbXIZWeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:34:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=NKuhzTTkkwT9YYHKGoTcJFrtgAbtWcyuxkKr/GQ6MbxGbxNZCp/qjVe1bbqjWUnSzBqa/GvmRz+ogQG/vcGzA/ZoD8e7wNxKSGJ71ee7VK+SFFanz+ixNMLW3bL+fiE8GzLCZSRw5ye1P4rSB4ikMEQlTojRHFa+145ihT/DfR8=
Date: Thu, 27 Sep 2007 01:33:44 +0300
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 1/3] Completely remove deprecated IRQ flags (SA_*)
Message-ID: <20070926223343.GA25905@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Only very little files use the deprecated SA_* IRQ flags in latest pull. This
minimal patch series removes such macros from the tree and transfrom old code
to the new IRQF_* flags.

Andrew, I've grepped the whole tree to make sure that no more files than the
patched ones use such deprecated macros. I hope this series won't introduce 
build errors.

Patches can be applied cleanly on v2.6.23-rc8.

==>

Get rid of the deprecated SA_* IRQ flags.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5523f19..00bdebb 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -55,28 +55,6 @@
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
 
-/*
- * Migration helpers. Scheduled for removal in 9/2007
- * Do not use for new code !
- */
-static inline
-unsigned long __deprecated deprecated_irq_flag(unsigned long flag)
-{
-	return flag;
-}
-
-#define SA_INTERRUPT		deprecated_irq_flag(IRQF_DISABLED)
-#define SA_SAMPLE_RANDOM	deprecated_irq_flag(IRQF_SAMPLE_RANDOM)
-#define SA_SHIRQ		deprecated_irq_flag(IRQF_SHARED)
-#define SA_PROBEIRQ		deprecated_irq_flag(IRQF_PROBE_SHARED)
-#define SA_PERCPU		deprecated_irq_flag(IRQF_PERCPU)
-
-#define SA_TRIGGER_LOW		deprecated_irq_flag(IRQF_TRIGGER_LOW)
-#define SA_TRIGGER_HIGH		deprecated_irq_flag(IRQF_TRIGGER_HIGH)
-#define SA_TRIGGER_FALLING	deprecated_irq_flag(IRQF_TRIGGER_FALLING)
-#define SA_TRIGGER_RISING	deprecated_irq_flag(IRQF_TRIGGER_RISING)
-#define SA_TRIGGER_MASK		deprecated_irq_flag(IRQF_TRIGGER_MASK)
-
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
 struct irqaction {


Regards,

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
