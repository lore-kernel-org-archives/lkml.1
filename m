Return-Path: <linux-kernel-owner+w=401wt.eu-S933031AbZKDVzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031AbZKDVzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932620AbZKDVzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:55:38 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35457 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997AbZKDVzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:55:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MDKVI3KRoTwOpxSyWmnhzYsbjPHG2wEaYRxbqkfFQyvuMldsJdF87T1syEdVOI/Nzy
         1JAeKYIqDupp3KpXHT1m/3F2KbHQjCEruL1VQ4/MOrOu2tVQMFQAlKCx8iqrUg7uWbhV
         Rvv5LUXblZKCVkrlfq5DBDHomUsP0WXIMm+rQ=
From: Paul Fertser <fercerpav@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       Rask Ingemann Lambertsen <rask@sygehus.dk>,
       Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 1/3] rtc: pcf50633: Fix month off-by-one error
Date: Thu,  5 Nov 2009 00:55:15 +0300
Message-Id: <1257371717-547-2-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1257371717-547-1-git-send-email-fercerpav@gmail.com>
References: <1257371717-547-1-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rask Ingemann Lambertsen <rask@sygehus.dk>

The PCF50633 stores a month value of 1-12, but the kernel wants 0-11.

Signed-off-by: Rask Ingemann Lambertsen <rask@sygehus.dk>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/rtc/rtc-pcf50633.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-pcf50633.c b/drivers/rtc/rtc-pcf50633.c
index f4dd87e..77b40dd 100644
--- a/drivers/rtc/rtc-pcf50633.c
+++ b/drivers/rtc/rtc-pcf50633.c
@@ -70,7 +70,7 @@ static void pcf2rtc_time(struct rtc_time *rtc, struct pcf50633_time *pcf)
 	rtc->tm_hour = bcd2bin(pcf->time[PCF50633_TI_HOUR]);
 	rtc->tm_wday = bcd2bin(pcf->time[PCF50633_TI_WKDAY]);
 	rtc->tm_mday = bcd2bin(pcf->time[PCF50633_TI_DAY]);
-	rtc->tm_mon = bcd2bin(pcf->time[PCF50633_TI_MONTH]);
+	rtc->tm_mon = bcd2bin(pcf->time[PCF50633_TI_MONTH]) - 1;
 	rtc->tm_year = bcd2bin(pcf->time[PCF50633_TI_YEAR]) + 100;
 }
 
@@ -81,7 +81,7 @@ static void rtc2pcf_time(struct pcf50633_time *pcf, struct rtc_time *rtc)
 	pcf->time[PCF50633_TI_HOUR] = bin2bcd(rtc->tm_hour);
 	pcf->time[PCF50633_TI_WKDAY] = bin2bcd(rtc->tm_wday);
 	pcf->time[PCF50633_TI_DAY] = bin2bcd(rtc->tm_mday);
-	pcf->time[PCF50633_TI_MONTH] = bin2bcd(rtc->tm_mon);
+	pcf->time[PCF50633_TI_MONTH] = bin2bcd(rtc->tm_mon + 1);
 	pcf->time[PCF50633_TI_YEAR] = bin2bcd(rtc->tm_year % 100);
 }
 
-- 
1.6.0.6

