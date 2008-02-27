Return-Path: <linux-kernel-owner+w=401wt.eu-S1758900AbYB0VVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900AbYB0VVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYB0VVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:21:20 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:49128 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbYB0VVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:21:20 -0500
Date: Wed, 27 Feb 2008 23:20:09 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Bernhard Walle <bwalle@suse.de>, p_gortmaker@yahoo.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/char/rtc.c: make 2 functions static
Message-ID: <20080227212009.GF29269@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following functions can now become static:
- rtc_interrupt()
- rtc_get_rtc_time()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 13 Feb 2008

 drivers/char/rtc.c  |    5 +++--
 include/linux/rtc.h |    2 --
 2 files changed, 3 insertions(+), 4 deletions(-)

e642155f0065ec03a83ed95eef2a78f272e73e01 
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index 78b151c..39aba90 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -144,6 +144,7 @@ static ssize_t rtc_read(struct file *file, char __user *buf,
 
 static int rtc_ioctl(struct inode *inode, struct file *file,
 		     unsigned int cmd, unsigned long arg);
+static void rtc_get_rtc_time(struct rtc_time *rtc_tm);
 
 #ifdef RTC_IRQ
 static unsigned int rtc_poll(struct file *file, poll_table *wait);
@@ -235,7 +236,7 @@ static inline unsigned char rtc_is_updating(void)
  *	(See ./arch/XXXX/kernel/time.c for the set_rtc_mmss() function.)
  */
 
-irqreturn_t rtc_interrupt(int irq, void *dev_id)
+static irqreturn_t rtc_interrupt(int irq, void *dev_id)
 {
 	/*
 	 *	Can be an alarm interrupt, update complete interrupt,
@@ -1298,7 +1299,7 @@ static int rtc_proc_open(struct inode *inode, struct file *file)
 }
 #endif
 
-void rtc_get_rtc_time(struct rtc_time *rtc_tm)
+static void rtc_get_rtc_time(struct rtc_time *rtc_tm)
 {
 	unsigned long uip_watchdog = jiffies, flags;
 	unsigned char ctrl;
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index f2d0d15..1fc4f60 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -208,8 +208,6 @@ typedef struct rtc_task {
 int rtc_register(rtc_task_t *task);
 int rtc_unregister(rtc_task_t *task);
 int rtc_control(rtc_task_t *t, unsigned int cmd, unsigned long arg);
-void rtc_get_rtc_time(struct rtc_time *rtc_tm);
-irqreturn_t rtc_interrupt(int irq, void *dev_id);
 
 #endif /* __KERNEL__ */
 

