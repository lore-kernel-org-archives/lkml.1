Return-Path: <linux-kernel-owner+w=401wt.eu-S935123AbXLQKUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935123AbXLQKUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 05:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763568AbXLQKUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 05:20:33 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:35972 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762619AbXLQKUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 05:20:32 -0500
From: Srinivasa Ds <srinivasa@in.ibm.com>
Organization: IBM
To: Johannes Weiner <hannes-kernel@saeurebad.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, rusty@rustcorp.com.au
Subject: [RFC] [patch 2/2] Refuse kprobe insertion on __init section code
Date: Mon, 17 Dec 2007 15:50:15 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <200712141225.30099.srinivasa@in.ibm.com> <x7wsrh78b8.fsf@saeurebad.de> <200712171545.36306.srinivasa@in.ibm.com>
In-Reply-To: <200712171545.36306.srinivasa@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712171550.15999.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes use of persistent_kernel_text_address() to avoid
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
+	if (!persistent_kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr))
 		return -EINVAL;
 
@@ -662,7 +662,7 @@ int __kprobes register_jprobe(struct jpr
 {
 	unsigned long addr = arch_deref_entry_point(jp->entry);
 
-	if (!kernel_text_address(addr))
+	if (!persistent_kernel_text_address(addr))
 		return -EINVAL;
 
 	/* Todo: Verify probepoint is a function entry point */
