Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbYFCR0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbYFCR0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYFCR0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:26:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:3837 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYFCR0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:26:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=ls14oez5IGkXoLU0KDkD8s7esL/IVIZ+Bg9OD7Icor0jCaFb/mwCiYK6mCGFZ4l/cf233H02QoaM835rPvq4etxunjZ7GY+XT3FqmaFUyoqEWdwM51C8W8QJs55eqKk3EFu1W/H3kbgJANf+IDfGk63mO2i+vCGWhkEJ1oTti8Q=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: change propagate_e820_map back to find_max_pfn -32bit - fix
Date: Tue, 3 Jun 2008 10:24:49 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806031024.50058.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


add memory_present calling for sparse and non numa

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -378,11 +378,13 @@ static unsigned long __init setup_memory
 	if (max_pfn > max_low_pfn) {
 		highstart_pfn = max_low_pfn;
 	}
+	memory_present(0, 0, highend_pfn);
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
 		pages_to_mb(highend_pfn - highstart_pfn));
 	num_physpages = highend_pfn;
 	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
 #else
+	memory_present(0, 0, max_low_pfn);
 	num_physpages = max_low_pfn;
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
 #endif
