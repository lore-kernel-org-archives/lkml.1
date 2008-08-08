Return-Path: <linux-kernel-owner+w=401wt.eu-S1762647AbYHHV7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762647AbYHHV7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbYHHVyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:54:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:58025 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762037AbYHHVyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:54:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QdTJQexIzISxrzkijot9gLzm2oG92prkMEso/+wGXBkkv7yd9rjyhSHyqmunBwzept
         aw0dBaq0MUOiYSGc6rmJF2AkeTRg0mSOZ9CrKZvo//pN/e3IGQiuommKeFVFDmHUrzHK
         aWukUCviCDoy+z/TpZreKo12YxnVTD7UkYlBg=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 14/42] drivers/rtc to use nr_irqs
Date: Fri,  8 Aug 2008 14:52:20 -0700
Message-Id: <1218232368-31228-15-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-14-git-send-email-yhlu.kernel@gmail.com>
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-10-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-11-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-12-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-13-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-14-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 drivers/rtc/rtc-vr41xx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index 884b635..834dcc6 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -360,7 +360,7 @@ static int __devinit rtc_probe(struct platform_device *pdev)
 	spin_unlock_irq(&rtc_lock);
 
 	aie_irq = platform_get_irq(pdev, 0);
-	if (aie_irq < 0 || aie_irq >= NR_IRQS) {
+	if (aie_irq < 0 || aie_irq >= nr_irqs) {
 		retval = -EBUSY;
 		goto err_device_unregister;
 	}
@@ -371,7 +371,7 @@ static int __devinit rtc_probe(struct platform_device *pdev)
 		goto err_device_unregister;
 
 	pie_irq = platform_get_irq(pdev, 1);
-	if (pie_irq < 0 || pie_irq >= NR_IRQS)
+	if (pie_irq < 0 || pie_irq >= nr_irqs)
 		goto err_free_irq;
 
 	retval = request_irq(pie_irq, rtclong1_interrupt, IRQF_DISABLED,
-- 
1.5.4.5

