Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbZDBELY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbZDBELY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZDBELE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:11:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:52978 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbZDBELA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:11:00 -0400
Date: Thu, 2 Apr 2009 04:09:41 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, davem@davemloft.net, tj@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, davem@davemloft.net, tj@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49D31770.9090502@kernel.org>
References: <49D31770.9090502@kernel.org>
Subject: [tip:x86/urgent] x86: remove duplicated code with pcpu_need_numa()
Message-ID: <tip-3de46fda4c104deef17ec70f85361f5c6b84ce0e@git.kernel.org>
Git-Commit-ID: 3de46fda4c104deef17ec70f85361f5c6b84ce0e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 04:09:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3de46fda4c104deef17ec70f85361f5c6b84ce0e
Gitweb:     http://git.kernel.org/tip/3de46fda4c104deef17ec70f85361f5c6b84ce0e
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 1 Apr 2009 00:27:44 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Apr 2009 06:08:05 +0200

x86: remove duplicated code with pcpu_need_numa()

Impact: clean up

those code pcpu_need_numa(), should be removed.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: David Miller <davem@davemloft.net>
LKML-Reference: <49D31770.9090502@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/setup_percpu.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 876b127..3a97a4c 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -153,7 +153,6 @@ static struct page * __init pcpur_get_page(unsigned int cpu, int pageno)
 static ssize_t __init setup_pcpu_remap(size_t static_size)
 {
 	static struct vm_struct vm;
-	pg_data_t *last;
 	size_t ptrs_size, dyn_size;
 	unsigned int cpu;
 	ssize_t ret;
@@ -165,19 +164,6 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
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
