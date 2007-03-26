Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670AbXCZFrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbXCZFrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 01:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbXCZFrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 01:47:22 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:51816 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbXCZFrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 01:47:21 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Mar 2007 01:47:20 EDT
From: "Mikael Starvik" <mikael.starvik@axis.com>
To: "'Adrian Bunk'" <bunk@stusta.de>,
       "Mikael Starvik" <mikael.starvik@axis.com>
Cc: "dev-etrax" <dev-etrax@axis.com>, <linux-kernel@vger.kernel.org>
Subject: RE: [2.6 patch] arch/cris/arch-v32/kernel/fasttimer.c: remove kernel 2.0 code
Date: Mon, 26 Mar 2007 07:41:31 +0200
Message-ID: <BFECAF9E178F144FAEF2BF4CE739C668030B5A36@exmail1.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1896
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C66804778EF5@exmail1.se.axis.com>
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I agree totally. 

Signed-off-by: Mikael Starvik <starvik@axis.com>

-----Original Message-----
From: Adrian Bunk [mailto:bunk@stusta.de] 
Sent: Monday, March 26, 2007 6:08 AM
To: Mikael Starvik
Cc: dev-etrax; linux-kernel@vger.kernel.org
Subject: [2.6 patch] arch/cris/arch-v32/kernel/fasttimer.c: remove kernel
2.0 code


This patch removes code for kernel 2.0 (sic).

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/cris/arch-v32/kernel/fasttimer.c |   36 ++------------------------
 1 file changed, 3 insertions(+), 33 deletions(-)

--- linux-2.6.21-rc4-mm1/arch/cris/arch-v32/kernel/fasttimer.c.old
2007-03-25 19:50:26.000000000 +0200
+++ linux-2.6.21-rc4-mm1/arch/cris/arch-v32/kernel/fasttimer.c	2007-03-25
19:52:36.000000000 +0200
@@ -602,38 +602,14 @@
 }
 
 #ifdef CONFIG_PROC_FS
-static int proc_fasttimer_read(char *buf, char **start, off_t offset, int
len
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
-                       ,int *eof, void *data_unused
-#else
-                        ,int unused
-#endif
-                               );
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
-static struct proc_dir_entry *fasttimer_proc_entry;
-#else
-static struct proc_dir_entry fasttimer_proc_entry =
-{
-  0, 9, "fasttimer",
-  S_IFREG | S_IRUGO, 1, 0, 0,
-  0, NULL /* ops -- default to array */,
-  &proc_fasttimer_read /* get_info */,
-};
-#endif
-#endif /* CONFIG_PROC_FS */
 
-#ifdef CONFIG_PROC_FS
+static struct proc_dir_entry *fasttimer_proc_entry;
 
 /* This value is very much based on testing */
 #define BIG_BUF_SIZE (500 + NUM_TIMER_STATS * 300)
 
-static int proc_fasttimer_read(char *buf, char **start, off_t offset, int
len
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
-                       ,int *eof, void *data_unused
-#else
-                        ,int unused
-#endif
-                               )
+static int proc_fasttimer_read(char *buf, char **start, off_t offset, int
len,
+			       int *eof, void *data_unused)
 {
   unsigned long flags;
   int i = 0;
@@ -808,9 +784,7 @@
 
   memcpy(buf, bigbuf + offset, len);
   *start = buf;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
   *eof = 1;
-#endif
 
   return len;
 }
@@ -974,12 +948,8 @@
     printk("fast_timer_init()\n");
 
 #ifdef CONFIG_PROC_FS
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
    if ((fasttimer_proc_entry = create_proc_entry( "fasttimer", 0, 0 )))
      fasttimer_proc_entry->read_proc = proc_fasttimer_read;
-#else
-    proc_register_dynamic(&proc_root, &fasttimer_proc_entry);
-#endif
 #endif /* PROC_FS */
     if(request_irq(TIMER_INTR_VECT, timer_trig_interrupt, IRQF_DISABLED,
                    "fast timer int", NULL))

