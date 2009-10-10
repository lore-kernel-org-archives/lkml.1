Return-Path: <linux-kernel-owner+w=401wt.eu-S1762012AbZJJPi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762012AbZJJPi7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761960AbZJJPiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:38:54 -0400
Received: from www.tglx.de ([62.245.132.106]:55604 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761994AbZJJPiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:38:50 -0400
Message-Id: <20091010153349.884891604@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:36:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 20/28] input: Remove BKL from hp_sdc_rtc
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=hp-sdc-rtc-remove-bkl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cycle_kernel_lock() was added during the big BKL pushdown. It should
ensure the serializiation against driver init code. In this case there
is nothing to serialize. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/misc/hp_sdc_rtc.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6-tip/drivers/input/misc/hp_sdc_rtc.c
===================================================================
--- linux-2.6-tip.orig/drivers/input/misc/hp_sdc_rtc.c
+++ linux-2.6-tip/drivers/input/misc/hp_sdc_rtc.c
@@ -35,7 +35,6 @@
 
 #include <linux/hp_sdc.h>
 #include <linux/errno.h>
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -409,7 +408,6 @@ static unsigned int hp_sdc_rtc_poll(stru
 
 static int hp_sdc_rtc_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
         return 0;
 }
 


