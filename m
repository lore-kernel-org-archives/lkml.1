Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZFWIwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZFWIwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbZFWIwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:52:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:43077 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbZFWIwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:52:13 -0400
Date: Tue, 23 Jun 2009 08:51:47 GMT
From: tip-bot for Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       arun@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       mpnayak@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arun@linux.vnet.ibm.com, tglx@linutronix.de, mpnayak@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20090623043058.GA3249@linux.vnet.ibm.com>
References: <20090623043058.GA3249@linux.vnet.ibm.com>
Subject: [tip:timers/urgent] timers: Fix timer_migration interface which accepts any number as input
Message-ID: <tip-bfdb4d9f0f611687d71cf6a460efc9e755f4a462@git.kernel.org>
Git-Commit-ID: bfdb4d9f0f611687d71cf6a460efc9e755f4a462
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 23 Jun 2009 08:51:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bfdb4d9f0f611687d71cf6a460efc9e755f4a462
Gitweb:     http://git.kernel.org/tip/bfdb4d9f0f611687d71cf6a460efc9e755f4a462
Author:     Arun R Bharadwaj <arun@linux.vnet.ibm.com>
AuthorDate: Tue, 23 Jun 2009 10:00:58 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 23 Jun 2009 10:49:33 +0200

timers: Fix timer_migration interface which accepts any number as input

Poornima Nayek reported:

| Timer migration interface /proc/sys/kernel/timer_migration in
| 2.6.30-git9 accepts any numerical value as input.
|
| Steps to reproduce:
| 1. echo -6666666 > /proc/sys/kernel/timer_migration
| 2. cat /proc/sys/kernel/timer_migration
| -6666666
|
| 1. echo 44444444444444444444444444444444444444444444444444444444444 > /proc/sys/kernel/timer_migration
| 2. cat /proc/sys/kernel/timer_migration
| -1357789412
|
| Expected behavior: Should 'echo: write error: Invalid argument' while
| setting any value other then 0 & 1

Restrict valid values to 0 and 1.

Reported-by: Poornima Nayak <mpnayak@linux.vnet.ibm.com>
Tested-by: Poornima Nayak <mpnayak@linux.vnet.ibm.com>
Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Cc: poornima nayak <mpnayak@linux.vnet.ibm.com>
Cc: Arun Bharadwaj <arun@linux.vnet.ibm.com>
LKML-Reference: <20090623043058.GA3249@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sysctl.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 62e4ff9..c428ba1 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -335,7 +335,10 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_timer_migration,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one,
 	},
 #endif
 	{
