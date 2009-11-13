Return-Path: <linux-kernel-owner+w=401wt.eu-S932228AbZKMTtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbZKMTtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932145AbZKMTtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:49:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:36007 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757001AbZKMTti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:49:38 -0500
Date: Fri, 13 Nov 2009 19:49:32 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] nohz: Type cast printk argument
Message-ID: <tip-529eaccd900a59724619b4a6ef6579fd518d5218@git.kernel.org>
Git-Commit-ID: 529eaccd900a59724619b4a6ef6579fd518d5218
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  529eaccd900a59724619b4a6ef6579fd518d5218
Gitweb:     http://git.kernel.org/tip/529eaccd900a59724619b4a6ef6579fd518d5218
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 13 Nov 2009 14:32:19 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 13 Nov 2009 20:46:24 +0100

nohz: Type cast printk argument

On some archs local_softirq_pending() has a data type of unsigned long
on others its unsigned int. Type cast it to (unsigned int) in the
printk to avoid the compiler warning.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
---
 kernel/time/tick-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3840f6d..c65ba0f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -250,7 +250,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 
 		if (ratelimit < 10) {
 			printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
-			       local_softirq_pending());
+			       (unsigned int) local_softirq_pending());
 			ratelimit++;
 		}
 		goto end;
