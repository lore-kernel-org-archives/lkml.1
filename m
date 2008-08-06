Return-Path: <linux-kernel-owner+w=401wt.eu-S1764608AbYHFIta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764608AbYHFIta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762162AbYHFIow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:44:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:12111 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764148AbYHFIou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:44:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KcFtQOsesBWnGsnsRO5tOnGprJ9r+kaHiID0kayAI4N4oImMm+sbgcU75qBY4LJgqs
         sTTmLEqC+/Gx7s3oaDUeQIJLSx/RgiglepUTH1r3zMKvAMznbammUNSCF+7+xs5lOXgi
         OBwU+Vec4ihFczIURch5Tmvz0HiIFuJ10O5j8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 12/33] drivers/pcmcia to use nr_irqs
Date: Wed,  6 Aug 2008 01:42:54 -0700
Message-Id: <1218012195-10429-13-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218012195-10429-12-git-send-email-yhlu.kernel@gmail.com>
References: <1218012195-10429-1-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-2-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-3-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-4-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-5-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-6-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-7-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-8-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-9-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-10-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-11-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-12-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 drivers/pcmcia/at91_cf.c      |    2 +-
 drivers/pcmcia/vrc4171_card.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index 6849685..194c8ba 100644
--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -273,7 +273,7 @@ static int __init at91_cf_probe(struct platform_device *pdev)
 			goto fail0d;
 		cf->socket.pci_irq = board->irq_pin;
 	} else
-		cf->socket.pci_irq = NR_IRQS + 1;
+		cf->socket.pci_irq = nr_irqs + 1;
 
 	/* pcmcia layer only remaps "real" memory not iospace */
 	cf->socket.io_offset = (unsigned long)
diff --git a/drivers/pcmcia/vrc4171_card.c b/drivers/pcmcia/vrc4171_card.c
index eee2f1c..b2c4124 100644
--- a/drivers/pcmcia/vrc4171_card.c
+++ b/drivers/pcmcia/vrc4171_card.c
@@ -639,7 +639,7 @@ static int __devinit vrc4171_card_setup(char *options)
 		int irq;
 		options += 4;
 		irq = simple_strtoul(options, &options, 0);
-		if (irq >= 0 && irq < NR_IRQS)
+		if (irq >= 0 && irq < nr_irqs)
 			vrc4171_irq = irq;
 
 		if (*options != ',')
-- 
1.5.4.5

