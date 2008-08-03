Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbYHCDGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbYHCDGf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 23:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbYHCDAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 23:00:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:10980 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbYHCDAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 23:00:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wQYH+zfAQ2RzUYQ812PUrDHCdEkPmWxZfV97u9dbQDkuhrfmnNLDiZcgDvCuYY9XvB
         yoboWWYUcTOD090tWCb+fgSUypIjFyb/k7Xbo7ZDel5M3erag1NVMlEHWKgEWRcwXFR0
         6NjBLtrAcoHdXT9rso6L6YfSItCirTUTQGJ+s=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 18/25] make irq_timer_state to use dyn_array
Date: Sat,  2 Aug 2008 19:59:18 -0700
Message-Id: <1217732365-16595-19-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217732365-16595-18-git-send-email-yhlu.kernel@gmail.com>
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-2-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-3-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-4-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-5-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-6-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-7-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-8-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-9-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-10-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-11-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-12-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-13-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-14-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-15-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-16-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-17-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-18-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 drivers/char/random.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index fdbdcfc..872669e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -558,7 +558,13 @@ struct timer_rand_state {
 };
 
 static struct timer_rand_state input_timer_state;
+
+#ifdef CONFIG_HAVE_DYN_ARRAY
+static struct timer_rand_state **irq_timer_state;
+DEFINE_DYN_ARRAY(irq_timer_state, sizeof(struct timer_rand_state *), nr_irqs, PAGE_SIZE, NULL);
+#else
 static struct timer_rand_state *irq_timer_state[NR_IRQS];
+#endif
 
 /*
  * This function adds entropy to the entropy "pool" by using timing
-- 
1.5.4.5

