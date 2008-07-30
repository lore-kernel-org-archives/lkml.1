Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbYG3VM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbYG3VM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757612AbYG3VJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:09:47 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:3175 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507AbYG3VJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:09:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Ua9HMdTluJCgjdn4uJhsLQy2gS3h61iuR6/RP1J3txXslrrJk+HpKAa48fsIwjYO5V
         zVny7lMCqu1lkAXs7Ryc2numh0sYGfbuLLwt7yyeVMPwzpRXcfFhooijG37F065hdP53
         b5C+eVvb+KxXdPVPlEHoCOmxUZneHSPtbX5PY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/7] random: make irq_timer_state to use dyn_array
Date: Wed, 30 Jul 2008 12:40:51 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807291414.55479.yhlu.kernel@gmail.com> <200807300311.48510.yhlu.kernel@gmail.com> <200807301210.31511.yhlu.kernel@gmail.com>
In-Reply-To: <200807301210.31511.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807301240.53062.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
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
