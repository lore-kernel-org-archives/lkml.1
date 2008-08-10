Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbYHJHmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbYHJHmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbYHJHiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:38:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:7020 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbYHJHiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Z2IJE5AdEWMwzWOp9bm0uN8YFSdlFbcz+Ao9KqaIdWmUBh2ugmF4CucSazvyc/5MhD
         RY/w35qejmPiJaUGijJNqXk+P+uT5Pm4ULIJom/tJMPg0DFeww49ncWxf66QtthCspG3
         IEPXjKDFvOssp/IA5B9lbKBZisJA4DQrX72nI=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 14/43] drivers/pcmcia to use nr_irqs
Date: Sun, 10 Aug 2008 00:36:03 -0700
Message-Id: <1218353792-3355-15-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218353792-3355-14-git-send-email-yhlu.kernel@gmail.com>
References: <1218353792-3355-1-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-2-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-3-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-4-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-5-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-6-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-7-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-8-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-9-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-10-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-11-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-12-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-13-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-14-git-send-email-yhlu.kernel@gmail.com>
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

