Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYAST6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYAST6U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 14:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYAST6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 14:58:07 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:22030 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYAST6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 14:58:06 -0500
Date: Sat, 19 Jan 2008 11:56:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: dipankar@in.ibm.com, akpm <akpm@linux-foundation.org>,
       samr <sam@ravnborg.org>
Subject: [PATCH] rcu: fix section mismatch
Message-Id: <20080119115643.43236e70.randy.dunlap@oracle.com>
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

rcu_online_cpu() should be __cpuinit instead of __devinit.

WARNING: vmlinux.o(.text+0x4b6d5): Section mismatch: reference to .init.text: (between 'rcu_cpu_notify' and 'wakeme_after_rcu')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/rcupdate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc8-git2.orig/kernel/rcupdate.c
+++ linux-2.6.24-rc8-git2/kernel/rcupdate.c
@@ -549,7 +549,7 @@ static void rcu_init_percpu_data(int cpu
 	rdp->blimit = blimit;
 }
 
-static void __devinit rcu_online_cpu(int cpu)
+static void __cpuinit rcu_online_cpu(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
 	struct rcu_data *bh_rdp = &per_cpu(rcu_bh_data, cpu);
