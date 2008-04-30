Return-Path: <linux-kernel-owner+w=401wt.eu-S1765386AbYD3U4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765386AbYD3U4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbYD3U4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:56:07 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39046 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231AbYD3U4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:56:05 -0400
Date: Wed, 30 Apr 2008 13:54:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-next@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>, mingo <mingo@redhat.com>,
       hpa <hpa@zytor.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] x86: fix setup printk format warning
Message-Id: <20080430135446.86c68516.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix x86 setup printk format warming:

next-20080430/arch/x86/kernel/setup.c:172: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'ssize_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- next-20080430.orig/arch/x86/kernel/setup.c
+++ next-20080430/arch/x86/kernel/setup.c
@@ -168,7 +168,7 @@ void __init setup_per_cpu_areas(void)
 
 	/* Copy section for each CPU (we discard the original) */
 	size = PERCPU_ENOUGH_ROOM;
-	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n",
+	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
 			  size);
 
 	for_each_possible_cpu(cpu) {
