Return-Path: <linux-kernel-owner+w=401wt.eu-S1763353AbYFEBXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763353AbYFEBXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 21:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763119AbYFEBWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 21:22:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63000 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1763015AbYFEBWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 21:22:04 -0400
Message-ID: <48473F59.7000908@cn.fujitsu.com>
Date: Thu, 05 Jun 2008 09:20:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, alan@redhat.com
Subject: [PATCH -mmotm] drivers/char/rtc.c: fix build failure
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch caused build failure:
	rtc-push-the-bkl-down-into-the-driver-ioctl-method.patch

drivers/char/rtc.c:721: error: conflicting types for ‘rtc_ioctl’
drivers/char/rtc.c:146: error: previous declaration of ‘rtc_ioctl’ was here

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 rtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/rtc.c.old	2008-06-05 09:11:20.000000000 +0800
+++ a/drivers/char/rtc.c	2008-06-05 09:11:28.000000000 +0800
@@ -143,7 +143,7 @@ static DEFINE_TIMER(rtc_irq_timer, rtc_d
 static ssize_t rtc_read(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos);
 
-static int rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 static void rtc_get_rtc_time(struct rtc_time *rtc_tm);
 
 #ifdef RTC_IRQ
