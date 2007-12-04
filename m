Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbXLDWCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbXLDWCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbXLDWBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:01:24 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:14442 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751922AbXLDWBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:01:23 -0500
Message-Id: <20071204215007.256459597@mvista.com>
References: <20071204215003.291002606@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 04 Dec 2007 00:00:02 -0800
Subject: [PATCH 2/3] drivers/isdn/i4l/isdn_tty.c: remove write_sem
References: <20071204214954.656363725@mvista.com>
User-Agent: quilt/0.46-1
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com
Content-Disposition: inline; filename=remove-isdn-write_sem.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I couldn't find any users, so removing it..

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/isdn/i4l/isdn_tty.c |    1 -
 include/linux/isdn.h        |    1 -
 2 files changed, 2 deletions(-)

Index: linux-2.6.23/drivers/isdn/i4l/isdn_tty.c
===================================================================
--- linux-2.6.23.orig/drivers/isdn/i4l/isdn_tty.c
+++ linux-2.6.23/drivers/isdn/i4l/isdn_tty.c
@@ -1915,7 +1915,6 @@ isdn_tty_modem_init(void)
 		info->owner = THIS_MODULE;
 #endif
 		spin_lock_init(&info->readlock);
-		init_MUTEX(&info->write_sem);
 		sprintf(info->last_cause, "0000");
 		sprintf(info->last_num, "none");
 		info->last_dir = 0;
Index: linux-2.6.23/include/linux/isdn.h
===================================================================
--- linux-2.6.23.orig/include/linux/isdn.h
+++ linux-2.6.23/include/linux/isdn.h
@@ -507,7 +507,6 @@ typedef struct modem_info {
   struct ktermios	normal_termios;  /* For saving termios structs     */
   struct ktermios	callout_termios;
   wait_queue_head_t	open_wait, close_wait;
-  struct semaphore      write_sem;
   spinlock_t	        readlock;
 } modem_info;
 

-- 
