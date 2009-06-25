Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbZFYTng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbZFYTng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbZFYTnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:43:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:45289 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757039AbZFYTnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:43:19 -0400
Date: Thu, 25 Jun 2009 19:42:46 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter: Split the mmap control page in two parts
Message-ID: <tip-41f95331b972a039f519ae0c70f051b7121f7346@git.kernel.org>
Git-Commit-ID: 41f95331b972a039f519ae0c70f051b7121f7346
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 25 Jun 2009 19:42:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41f95331b972a039f519ae0c70f051b7121f7346
Gitweb:     http://git.kernel.org/tip/41f95331b972a039f519ae0c70f051b7121f7346
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 23 Jun 2009 17:55:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Jun 2009 21:39:05 +0200

perf_counter: Split the mmap control page in two parts

Since there are two distinct sections to the control page,
move them apart so that possible extentions don't overlap.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index e7213e4..489d5cb 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -233,6 +233,12 @@ struct perf_counter_mmap_page {
 	__u32	index;			/* hardware counter identifier */
 	__s64	offset;			/* add to hardware counter value */
 
+		/*
+		 * Hole for extension of the self monitor capabilities
+		 */
+
+	__u64	__reserved[125];	/* align to 1k */
+
 	/*
 	 * Control data for the mmap() data buffer.
 	 *
