Return-Path: <linux-kernel-owner+w=401wt.eu-S934535AbYAaWs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934535AbYAaWs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762320AbYAaWst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:48:49 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:41425 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761188AbYAaWss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:48:48 -0500
Date: Thu, 31 Jan 2008 14:55:47 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: remove unneeded round_up
In-reply-to: <20080131210553.GA15221@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-id: <200801311455.48573.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801291113.35974.yinghai.lu@sun.com>
 <200801311244.11206.yinghai.lu@sun.com> <20080131210553.GA15221@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: remove unneeded round_up

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index d585d27..5a02bf4 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -168,10 +168,9 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 	unsigned long mem = find_e820_area(start, end, size, align);
 	void *ptr;
 
-	if (mem != -1L) {
-		mem = round_up(mem, align);
+	if (mem != -1L)
 		return __va(mem);
-	}
+
 	ptr = __alloc_bootmem_nopanic(size, align, __pa(MAX_DMA_ADDRESS));
 	if (ptr == NULL) {
 		printk(KERN_ERR "Cannot find %lu bytes in node %d\n",
