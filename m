Return-Path: <linux-kernel-owner+w=401wt.eu-S932721AbZKDWC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721AbZKDWC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 17:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758252AbZKDWC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 17:02:27 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56879 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190AbZKDWC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 17:02:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uG5oCNL5Rrq+SJMst0LL1gfdjRCaT2YnMMluMEWN9afi8ZqEx9KPqMRuScxC4Fcsn9
         KpuJAD3vivf6lwrBDebOShxocvpEoUfvka0Bineo1J/jKFFFm/4//Ru1d2eDDEbcKNtq
         e/PLJcs9fHnEcUKsOUd39McYDOlls3ZeF4pkk=
From: Paul Fertser <fercerpav@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       Werner Almesberger <werner@openmoko.org>,
       Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 2/3] rtc: pcf50633: consider alrm->enable in pcf50633_rtc_set_alarm
Date: Thu,  5 Nov 2009 00:55:16 +0300
Message-Id: <1257371717-547-3-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1257371717-547-2-git-send-email-fercerpav@gmail.com>
References: <1257371717-547-1-git-send-email-fercerpav@gmail.com>
 <1257371717-547-2-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Werner Almesberger <werner@openmoko.org>

According to Documentation/rtc.txt, RTC_WKALM_SET sets the alarm time
and enables/disables the alarm. We implement RTC_WKALM_SET through
pcf50633_rtc_set_alarm. The enabling/disabling part was missing.

Signed-off-by: Werner Almesberger <werner@openmoko.org>
Reported-by: Michael 'Mickey' Lauer <mickey@openmoko.org>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/rtc/rtc-pcf50633.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-pcf50633.c b/drivers/rtc/rtc-pcf50633.c
index 77b40dd..33a10c4 100644
--- a/drivers/rtc/rtc-pcf50633.c
+++ b/drivers/rtc/rtc-pcf50633.c
@@ -245,8 +245,9 @@ static int pcf50633_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	ret = pcf50633_write_block(rtc->pcf, PCF50633_REG_RTCSCA,
 				PCF50633_TI_EXTENT, &pcf_tm.time[0]);
 
-	if (!alarm_masked)
+	if (!alarm_masked || alrm->enabled)
 		pcf50633_irq_unmask(rtc->pcf, PCF50633_IRQ_ALARM);
+	rtc->alarm_enabled = alrm->enabled;
 
 	return ret;
 }
-- 
1.6.0.6

