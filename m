Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbYEESit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbYEESit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761465AbYEES3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:29:43 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55236 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761460AbYEES3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:29:41 -0400
Date: Mon, 5 May 2008 21:28:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Bernhard Walle <bwalle@suse.de>, Paul Gortmaker <p_gortmaker@yahoo.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] drivers/char/rtc.c: make 2 functions static
Message-ID: <20080505182834.GO17139@cs181133002.pp.htv.fi>
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
Acked-by: Bernhard Walle <bwalle@suse.de>
Acked-by:  Paul Gortmaker <p_gortmaker@yahoo.com>

---

This patch has been sent on:
- 22 Apr 2008
- 14 Apr 2008
- 31 Mar 2008
- 27 Feb 2008
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
 

