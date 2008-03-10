Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbYCJSKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbYCJSKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 14:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYCJSKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 14:10:23 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:36103 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYCJSKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:10:22 -0400
Subject: [RFC PATCH] ipv4: compilation error fix with CONFIG_PROC_FS
	disabled
From: Ram Pai <linuxram@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net
Content-Type: text/plain
Date: Mon, 10 Mar 2008 11:11:03 -0700
Message-Id: <1205172664.15345.96.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes compilation errors while compiling the kernel with CONFIG_PROC_FS
disabled.


Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 net/ipv4/fib_frontend.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.24/net/ipv4/fib_frontend.c
===================================================================
--- linux-2.6.24.orig/net/ipv4/fib_frontend.c
+++ linux-2.6.24/net/ipv4/fib_frontend.c
@@ -1029,14 +1029,19 @@ static int __net_init fib_net_init(struc
 	error = nl_fib_lookup_init(net);
 	if (error < 0)
 		goto out_nlfl;
+#ifdef CONFIG_PROC_FS
 	error = fib_proc_init(net);
 	if (error < 0)
 		goto out_proc;
+#endif /* CONFIG_PROC_FS */
 out:
 	return error;
 
+#ifdef CONFIG_PROC_FS
 out_proc:
 	nl_fib_lookup_exit(net);
+#endif /* CONFIG_PROC_FS */
+
 out_nlfl:
 	ip_fib_net_exit(net);
 	goto out;
@@ -1044,7 +1049,9 @@ out_nlfl:
 
 static void __net_exit fib_net_exit(struct net *net)
 {
+#ifdef CONFIG_PROC_FS
 	fib_proc_exit(net);
+#endif /* CONFIG_PROC_FS */
 	nl_fib_lookup_exit(net);
 	ip_fib_net_exit(net);
 }


