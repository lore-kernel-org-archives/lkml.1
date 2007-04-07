Return-Path: <linux-kernel-owner+w=401wt.eu-S966341AbXDGUoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966341AbXDGUoL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 16:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966344AbXDGUoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 16:44:11 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:56088 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966341AbXDGUoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 16:44:10 -0400
X-Originating-Ip: 74.109.98.130
Date: Sat, 7 Apr 2007 16:42:59 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, starvik@axis.com
Subject: [PATCH] CRIS: Remove code related to pre-2.2 kernel.
Message-ID: <Pine.LNX.4.64.0704071641050.14248@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove conditionals and code related to checking for a pre-2.2
kernel.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

i'm fairly certain there's no value in checking for pre-2.2 kernels
anymore.  (not compile tested as i have no such system.)


diff --git a/arch/cris/arch-v32/kernel/fasttimer.c b/arch/cris/arch-v32/kernel/fasttimer.c
index 5daeb6f..79e1e4c 100644
--- a/arch/cris/arch-v32/kernel/fasttimer.c
+++ b/arch/cris/arch-v32/kernel/fasttimer.c
@@ -603,23 +603,8 @@ void schedule_usleep(unsigned long us)

 #ifdef CONFIG_PROC_FS
 static int proc_fasttimer_read(char *buf, char **start, off_t offset, int len
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
-                       ,int *eof, void *data_unused
-#else
-                        ,int unused
-#endif
-                               );
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
+                       ,int *eof, void *data_unused);
 static struct proc_dir_entry *fasttimer_proc_entry;
-#else
-static struct proc_dir_entry fasttimer_proc_entry =
-{
-  0, 9, "fasttimer",
-  S_IFREG | S_IRUGO, 1, 0, 0,
-  0, NULL /* ops -- default to array */,
-  &proc_fasttimer_read /* get_info */,
-};
-#endif
 #endif /* CONFIG_PROC_FS */

 #ifdef CONFIG_PROC_FS
@@ -628,12 +613,7 @@ static struct proc_dir_entry fasttimer_proc_entry =
 #define BIG_BUF_SIZE (500 + NUM_TIMER_STATS * 300)

 static int proc_fasttimer_read(char *buf, char **start, off_t offset, int len
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
-                       ,int *eof, void *data_unused
-#else
-                        ,int unused
-#endif
-                               )
+                       ,int *eof, void *data_unused)
 {
   unsigned long flags;
   int i = 0;
@@ -808,9 +788,7 @@ static int proc_fasttimer_read(char *buf, char **start, off_t offset, int len

   memcpy(buf, bigbuf + offset, len);
   *start = buf;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,2,0)
   *eof = 1;
-#endif

   return len;
 }
@@ -974,12 +952,8 @@ void fast_timer_init(void)
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
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
