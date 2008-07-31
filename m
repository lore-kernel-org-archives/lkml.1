Return-Path: <linux-kernel-owner+w=401wt.eu-S1751528AbYGaENl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbYGaENl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 00:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYGaENQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 00:13:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:33082 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbYGaENP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 00:13:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=WtlXfQ26ZnEGYLCxkyQIITKvxZWCYcTI8m6ef4xGZZu8aR5/UTbwxfCrwnXZO04Diz
         7AhKZWyseYVwaB7Z7Z+F622z8Wo59gy9OJ5NLLQRTG10bNXp0/YHRtrlAZIluAEz0WwB
         ETQpRF8BWJ8VZmCuus2fEv3+ffQRJXT10OFeE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] serial: change irq_lists to use dyn_array
Date: Wed, 30 Jul 2008 21:10:10 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807291414.55479.yhlu.kernel@gmail.com> <200807301210.31511.yhlu.kernel@gmail.com> <200807302109.21519.yhlu.kernel@gmail.com>
In-Reply-To: <200807302109.21519.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807302110.10585.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/serial/8250.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/drivers/serial/8250.c
===================================================================
--- linux-2.6.orig/drivers/serial/8250.c
+++ linux-2.6/drivers/serial/8250.c
@@ -149,7 +149,12 @@ struct irq_info {
 	struct list_head	*head;
 };
 
+#if defined(CONFIG_HAVE_DYN_ARRAY) && !defined(MODULE)
+static struct irq_info *irq_lists;
+DEFINE_DYN_ARRAY(irq_lists, sizeof(struct irq_info), nr_irqs, PAGE_SIZE, NULL);
+#else
 static struct irq_info irq_lists[NR_IRQS];
+#endif
 
 /*
  * Here we define the default xmit fifo size used for each type of UART.
