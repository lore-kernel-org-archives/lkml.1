Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbYAST7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbYAST7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 14:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYAST73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 14:59:29 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:22564 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbYAST72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 14:59:28 -0500
Date: Sat, 19 Jan 2008 11:57:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: tglx <tglx@linutronix.de>, akpm <akpm@linux-foundation.org>,
       samr <sam@ravnborg.org>, johannes@sipsolutions.net
Subject: [PATCH] hrtimer: fix section mismatch
Message-Id: <20080119115710.520090e4.randy.dunlap@oracle.com>
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

Fix section mismatch in hrtimer.c:

WARNING: vmlinux.o(.text+0x50c61): Section mismatch: reference to .init.text: (between 'hrtimer_cpu_notify' and 'down_read_trylock')

Noticed by Johannes Berg and confirmed by Sam Ravnborg.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/hrtimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc8-git2.orig/kernel/hrtimer.c
+++ linux-2.6.24-rc8-git2/kernel/hrtimer.c
@@ -1378,7 +1378,7 @@ sys_nanosleep(struct timespec __user *rq
 /*
  * Functions related to boot-time initialization:
  */
-static void __devinit init_hrtimers_cpu(int cpu)
+static void __cpuinit init_hrtimers_cpu(int cpu)
 {
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
 	int i;
