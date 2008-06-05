Return-Path: <linux-kernel-owner+w=401wt.eu-S1760626AbYFESLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626AbYFESLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYFESLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:11:12 -0400
Received: from xenotime.net ([66.160.160.81]:45212 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753293AbYFESLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:11:11 -0400
Date: Thu, 5 Jun 2008 11:10:59 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: [PATCH -next] x86: fix longstanding setup.c printk format warning
Message-ID: <Pine.LNX.4.64.0806051107200.702@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Note: for -next only, not mainline.

Fix setup.c printk format warning:

linux-next-20080605/arch/x86/kernel/setup.c: In function 'setup_per_cpu_areas':
linux-next-20080605/arch/x86/kernel/setup.c:173: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'ssize_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20080605.orig/arch/x86/kernel/setup.c
+++ linux-next-20080605/arch/x86/kernel/setup.c
@@ -169,7 +169,7 @@ void __init setup_per_cpu_areas(void)
 
 	/* Copy section for each CPU (we discard the original) */
 	size = PERCPU_ENOUGH_ROOM;
-	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n",
+	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
 			  size);
 
 	for_each_possible_cpu(cpu) {
