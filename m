Return-Path: <linux-kernel-owner+w=401wt.eu-S1764272AbXLNJeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764272AbXLNJeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 04:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757285AbXLNJei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 04:34:38 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:50612 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbXLNJeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 04:34:37 -0500
From: Srinivasa Ds <srinivasa@in.ibm.com>
Organization: IBM
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [patch 2/2] Refuse kprobe insertion on __init section code
Date: Fri, 14 Dec 2007 15:04:50 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, rusty@rustcorp.com.au
References: <200712141225.30099.srinivasa@in.ibm.com> <20071213230916.cd30de8c.akpm@linux-foundation.org>
In-Reply-To: <20071213230916.cd30de8c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141504.50479.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes use of regular_kernel_text_address() to avoid
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
+	if (!regular_kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr))
 		return -EINVAL;
 
@@ -662,7 +662,7 @@ int __kprobes register_jprobe(struct jpr
 {
 	unsigned long addr = arch_deref_entry_point(jp->entry);
 
-	if (!kernel_text_address(addr))
+	if (!regular_kernel_text_address(addr))
 		return -EINVAL;
 
 	/* Todo: Verify probepoint is a function entry point */
