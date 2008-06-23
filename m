Return-Path: <linux-kernel-owner+w=401wt.eu-S1759405AbYFWVBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405AbYFWVBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 17:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbYFWVBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 17:01:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:9030 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbYFWVBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 17:01:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=lsb9O42fhvca9bOZCR6LVbWvw0/b51OdkNOTQIOZUpv21TlzM0QlCN/X4YZT1YnL/l
         iO3R7tACxzNXIvbQH2qBQwv5W+Wg25z1t/MTTktQGybtOvpfB2QIDc5ada0lgjX7zjVy
         mNksZneeE8oeO+xHRFn44AaDoUOttaU39qP5I=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: fix compiling warning in init_64.c
Date: Mon, 23 Jun 2008 14:02:36 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231402.36752.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


len is long and ret is only for NUMA

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -849,9 +849,9 @@ int __init reserve_bootmem_generic(unsig
 {
 #ifdef CONFIG_NUMA
 	int nid, next_nid;
+	int ret;
 #endif
 	unsigned long pfn = phys >> PAGE_SHIFT;
-	int ret;
 
 	if (pfn >= end_pfn) {
 		/*
@@ -861,7 +861,7 @@ int __init reserve_bootmem_generic(unsig
 		if (pfn < max_pfn_mapped)
 			return -EFAULT;
 
-		printk(KERN_ERR "reserve_bootmem: illegal reserve %lx %u\n",
+		printk(KERN_ERR "reserve_bootmem: illegal reserve %lx %lu\n",
 				phys, len);
 		return -EFAULT;
 	}
