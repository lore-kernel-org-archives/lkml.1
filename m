Return-Path: <linux-kernel-owner+w=401wt.eu-S1761577AbXLNG5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577AbXLNG5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXLNG5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:57:06 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:40900 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbXLNG5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:57:03 -0500
From: Srinivasa Ds <srinivasa@in.ibm.com>
Organization: IBM
To: linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: [RFC] [patch 2/2] Refuse kprobe insertion on __init section code
Date: Fri, 14 Dec 2007 12:27:15 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: rusty@rustcorp.com.au
References: <200712141225.30099.srinivasa@in.ibm.com>
In-Reply-To: <200712141225.30099.srinivasa@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141227.15390.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes use of non_init_kernel_text_address() to avoid
probing __init functions.

Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>


---
 kernel/kprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.24-rc5-mm1/kernel/kprobes.c
===================================================================
--- linux-2.6.24-rc5-mm1.orig/kernel/kprobes.c
+++ linux-2.6.24-rc5-mm1/kernel/kprobes.c
@@ -520,7 +520,7 @@ static int __kprobes __register_kprobe(s
 		return -EINVAL;
 	p->addr = (kprobe_opcode_t *)(((char *)p->addr)+ p->offset);
 
-	if (!kernel_text_address((unsigned long) p->addr) ||
+	if (!non_init_kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr))
 		return -EINVAL;
 
@@ -662,7 +662,7 @@ int __kprobes register_jprobe(struct jpr
 {
 	unsigned long addr = arch_deref_entry_point(jp->entry);
 
-	if (!kernel_text_address(addr))
+	if (!non_init_kernel_text_address(addr))
 		return -EINVAL;
 
 	/* Todo: Verify probepoint is a function entry point */
