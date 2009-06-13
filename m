Return-Path: <linux-kernel-owner+w=401wt.eu-S1762862AbZFMOuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762862AbZFMOuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbZFMOth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:49:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:49032 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbZFMOtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:49:36 -0400
Date: Sat, 13 Jun 2009 14:49:09 GMT
From: tip-bot for Marti Raudsepp <marti@juffo.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       marti@juffo.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       marti@juffo.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Fix stack corruption in perf_read_hw
Message-ID: <tip-d5e8da6449d4ef4bac35ea9b9719a2cda02e7b39@git.kernel.org>
Git-Commit-ID: d5e8da6449d4ef4bac35ea9b9719a2cda02e7b39
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 13 Jun 2009 14:49:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d5e8da6449d4ef4bac35ea9b9719a2cda02e7b39
Gitweb:     http://git.kernel.org/tip/d5e8da6449d4ef4bac35ea9b9719a2cda02e7b39
Author:     Marti Raudsepp <marti@juffo.org>
AuthorDate: Sat, 13 Jun 2009 02:35:01 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 13 Jun 2009 12:58:24 +0200

perf_counter: Fix stack corruption in perf_read_hw

With PERF_FORMAT_ID, perf_read_hw now needs space for up to 4 values.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 8d14a73..e914daf 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1553,7 +1553,7 @@ static int perf_release(struct inode *inode, struct file *file)
 static ssize_t
 perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 {
-	u64 values[3];
+	u64 values[4];
 	int n;
 
 	/*
