Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbYHAJwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbYHAJwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYHAJw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:52:26 -0400
Received: from qb-out-0506.google.com ([72.14.204.233]:15979 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbYHAJwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:52:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tBsRGC+BOypB4qHBqNWpHcH36eYa6Zdpm7p4UmA8A1yBGV9HE9aROxCtGIKspoYSsZ
         1/TjpAmSCkTLByaPFdhK0cso2hNKytjO5ZJDmqwQX1zKRsoNvJVHYj6H7ZF8DIFr47pJ
         ooceTXSkrlplledJdm2/GKuLMDe6luRhdcuJE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 04/16] make irq_timer_state to use dyn_array
Date: Fri,  1 Aug 2008 02:37:32 -0700
Message-Id: <1217583464-28494-5-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217583464-28494-4-git-send-email-yhlu.kernel@gmail.com>
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-2-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-3-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-4-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/char/random.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/drivers/char/random.c
===================================================================
--- linux-2.6.orig/drivers/char/random.c
+++ linux-2.6/drivers/char/random.c
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
