Return-Path: <linux-kernel-owner+w=401wt.eu-S934735AbZJNPvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934735AbZJNPvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934709AbZJNPvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:51:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:34621 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934526AbZJNPvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:51:06 -0400
Date: Wed, 14 Oct 2009 15:49:56 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       geert@linux-m68k.org, dtor@mail.ru, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       geert@linux-m68k.org, dtor@mail.ru, tglx@linutronix.de
In-Reply-To: <20091010153349.884891604@linutronix.de>
References: <20091010153349.884891604@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/drivers] input: Remove BKL from hp_sdc_rtc
Message-ID: <tip-d2d23559857e5f34762c61487f8ffb2fa4d7442d@git.kernel.org>
Git-Commit-ID: d2d23559857e5f34762c61487f8ffb2fa4d7442d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:49:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2d23559857e5f34762c61487f8ffb2fa4d7442d
Gitweb:     http://git.kernel.org/tip/d2d23559857e5f34762c61487f8ffb2fa4d7442d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 10 Oct 2009 12:41:43 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:36:51 +0200

input: Remove BKL from hp_sdc_rtc

cycle_kernel_lock() was added during the big BKL pushdown. It should
ensure the serializiation against driver init code. In this case there
is nothing to serialize. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091010153349.884891604@linutronix.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/misc/hp_sdc_rtc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/input/misc/hp_sdc_rtc.c b/drivers/input/misc/hp_sdc_rtc.c
index 216a559..4d1aa9a 100644
--- a/drivers/input/misc/hp_sdc_rtc.c
+++ b/drivers/input/misc/hp_sdc_rtc.c
@@ -35,7 +35,6 @@
 
 #include <linux/hp_sdc.h>
 #include <linux/errno.h>
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -409,7 +408,6 @@ static unsigned int hp_sdc_rtc_poll(struct file *file, poll_table *wait)
 
 static int hp_sdc_rtc_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
         return 0;
 }
 
