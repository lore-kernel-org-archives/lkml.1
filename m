Return-Path: <linux-kernel-owner+w=401wt.eu-S1764894AbYHFIwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764894AbYHFIwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764218AbYHFIpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:45:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:12111 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759668AbYHFIpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:45:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=D1W0XmxqRuElUagGCZIpHCDfgjvD7t6cEq7ns7iiuaIQkL05yT/kAGqVex6wbuGLy5
         9i8xQxsPCx28HQPPeN70LqwCgS2DTzRD2AvWb9rheX3ERduuxsakYCpyn2LQ1pPrW/pR
         UfToICq3S9Sg0sPDASpEjjadnXrfZuw3mEZ3M=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 18/33] make irq_timer_state to use dyn_array
Date: Wed,  6 Aug 2008 01:43:00 -0700
Message-Id: <1218012195-10429-19-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218012195-10429-18-git-send-email-yhlu.kernel@gmail.com>
References: <1218012195-10429-1-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-2-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-3-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-4-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-5-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-6-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-7-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-8-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-9-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-10-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-11-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-12-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-13-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-14-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-15-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-16-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-17-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-18-git-send-email-yhlu.kernel@gmail.com>
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

