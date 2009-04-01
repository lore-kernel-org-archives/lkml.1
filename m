Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbZDAH2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbZDAH2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 03:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbZDAH2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 03:28:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:42135 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbZDAH2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 03:28:36 -0400
Message-ID: <49D31770.9090502@kernel.org>
Date: Wed, 01 Apr 2009 00:27:44 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: remove duplicated code with pcpu_need_numa()
References: <20090331.223128.143365884.davem@davemloft.net> <86802c440903312256r6ddbaa22o5c23cf85d83a6662@mail.gmail.com> <49D30469.8020006@kernel.org>
In-Reply-To: <49D30469.8020006@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: clean up

those code pcpu_need_numa(), should be removed.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup_percpu.c |   14 --------------
 1 file changed, 14 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_percpu.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6/arch/x86/kernel/setup_percpu.c
@@ -153,7 +153,6 @@ static struct page * __init pcpur_get_pa
 static ssize_t __init setup_pcpu_remap(size_t static_size)
 {
 	static struct vm_struct vm;
-	pg_data_t *last;
 	size_t ptrs_size, dyn_size;
 	unsigned int cpu;
 	ssize_t ret;
@@ -165,19 +164,6 @@ static ssize_t __init setup_pcpu_remap(s
 	if (!cpu_has_pse || !pcpu_need_numa())
 		return -EINVAL;
 
-	last = NULL;
-	for_each_possible_cpu(cpu) {
-		int node = early_cpu_to_node(cpu);
-
-		if (node_online(node) && NODE_DATA(node) &&
-		    last && last != NODE_DATA(node))
-			goto proceed;
-
-		last = NODE_DATA(node);
-	}
-	return -EINVAL;
-
-proceed:
 	/*
 	 * Currently supports only single page.  Supporting multiple
 	 * pages won't be too difficult if it ever becomes necessary.
