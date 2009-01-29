Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbZA2DYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbZA2DYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 22:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZA2DYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 22:24:41 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:38022 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbZA2DYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 22:24:40 -0500
Message-ID: <49812168.7070708@oracle.com>
Date: Wed, 28 Jan 2009 19:24:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mmotm] fix more cpuset breakage
References: <200901290142.n0T1gq02009439@imap1.linux-foundation.org>
In-Reply-To: <200901290142.n0T1gq02009439@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4981216B.01A2:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Not everyone uses cpusets, so fix the b0rked build (part 2):

kernel/kthread.c:243: error: 'struct task_struct' has no member named 'mems_allowed'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/kthread.c |    2 ++
 1 file changed, 2 insertions(+)

--- mmotm-2009-0128-1742.orig/kernel/kthread.c
+++ mmotm-2009-0128-1742/kernel/kthread.c
@@ -240,7 +240,9 @@ int kthreadd(void *unused)
 	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
 	set_cpus_allowed_ptr(tsk, CPU_MASK_ALL_PTR);
 
+#ifdef CONFIG_CPUSETS
 	current->mems_allowed = node_possible_map;
+#endif
 	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
 
 	for (;;) {
