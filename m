Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYG2HiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYG2HiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 03:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYG2Hh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 03:37:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:15259 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbYG2Hh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 03:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=NkE91zvheVjH7ijaQvJpuxXblVIYZrQg4pbZFOTvRluZRy+HUKDdKLemWJweZfPWAn
         KW5iH+8p+Y+blJzZzDjCsy72Vme9jwy9kBvZerlElRmN1nyad43zkTTGDQAsUfNXgsz+
         +Hty/LjNzqGE0epV+v6G1H3NYw81m1DcOnYho=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: print per_cpu data address
Date: Tue, 29 Jul 2008 00:37:10 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807290037.11101.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


to make sure per_cpu data on correct node.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup_percpu.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/setup_percpu.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6/arch/x86/kernel/setup_percpu.c
@@ -162,9 +162,16 @@ void __init setup_per_cpu_areas(void)
 			printk(KERN_INFO
 			       "cpu %d has no node %d or node-local memory\n",
 				cpu, node);
+			if (ptr)
+				printk(KERN_DEBUG "per cpu data for cpu%d at %016lx\n",
+					 cpu, __pa(ptr));
 		}
-		else
+		else {
 			ptr = alloc_bootmem_pages_node(NODE_DATA(node), size);
+			if (ptr)
+				printk(KERN_DEBUG "per cpu data for cpu%d on node%d at %016lx\n",
+					 cpu, node, __pa(ptr));
+		}
 #endif
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
