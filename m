Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbZGSPT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbZGSPT2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 11:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbZGSPT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 11:19:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:46053 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbZGSPTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 11:19:25 -0400
Date: Sun, 19 Jul 2009 15:19:00 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       error27@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       error27@gmail.com, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.00.0907191545580.12306@bicker>
References: <alpine.DEB.2.00.0907191545580.12306@bicker>
Subject: [tip:timers/urgent] clocksource: Prevent NULL pointer dereference
Message-ID: <tip-79ef2bb01445400def20c7993b27fbcad27ca95f@git.kernel.org>
Git-Commit-ID: 79ef2bb01445400def20c7993b27fbcad27ca95f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 19 Jul 2009 15:19:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79ef2bb01445400def20c7993b27fbcad27ca95f
Gitweb:     http://git.kernel.org/tip/79ef2bb01445400def20c7993b27fbcad27ca95f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 19 Jul 2009 17:09:12 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 19 Jul 2009 17:15:54 +0200

clocksource: Prevent NULL pointer dereference

Writing a zero length string to sys/.../current_clocksource will cause
a NULL pointer dereference if the clock events system is in one shot
(highres or nohz) mode.

Pointed-out-by: Dan Carpenter <error27@gmail.com>
LKML-Reference: <alpine.DEB.2.00.0907191545580.12306@bicker>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/time/clocksource.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 592bf58..7466cb8 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -513,7 +513,7 @@ static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 	 * Check to make sure we don't switch to a non-highres capable
 	 * clocksource if the tick code is in oneshot mode (highres or nohz)
 	 */
-	if (tick_oneshot_mode_active() &&
+	if (tick_oneshot_mode_active() && ovr &&
 	    !(ovr->flags & CLOCK_SOURCE_VALID_FOR_HRES)) {
 		printk(KERN_WARNING "%s clocksource is not HRT compatible. "
 			"Cannot switch while in HRT/NOHZ mode\n", ovr->name);
