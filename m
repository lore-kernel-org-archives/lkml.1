Return-Path: <linux-kernel-owner+w=401wt.eu-S1758515AbYHCDEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515AbYHCDEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 23:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYHCDAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 23:00:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:17221 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbYHCDAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 23:00:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=atKVy2/OTvPZ/Hz5IvejsGt7kEtR0RdqP4uFRU2SW450FtKajyOvQy9ANYZW8JcrtX
         VU5owlut2kfz+xuk0OaVeEy0o4HUYSG5Xj2nzA9s5B7nGkrcdAvfMnn10TJQA+DZaJEy
         EnHonZooYmttiY4o2TvFqmg9Ux076mttYRt3M=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 12/25] drivers/pcmcia to use nr_irqs
Date: Sat,  2 Aug 2008 19:59:12 -0700
Message-Id: <1217732365-16595-13-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217732365-16595-12-git-send-email-yhlu.kernel@gmail.com>
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-2-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-3-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-4-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-5-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-6-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-7-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-8-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-9-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-10-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-11-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-12-git-send-email-yhlu.kernel@gmail.com>
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

