Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbZFASnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbZFASnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 14:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZFASnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 14:43:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:60019 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbZFASnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 14:43:00 -0400
Date: Mon, 1 Jun 2009 18:42:32 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Guard against record damaging existing files
Message-ID: <tip-229c4eedcedcdadf70411120ba34bc37554a74bd@git.kernel.org>
Git-Commit-ID: 229c4eedcedcdadf70411120ba34bc37554a74bd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Jun 2009 18:42:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  229c4eedcedcdadf70411120ba34bc37554a74bd
Gitweb:     http://git.kernel.org/tip/229c4eedcedcdadf70411120ba34bc37554a74bd
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 28 May 2009 16:28:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 1 Jun 2009 20:10:24 +0200

perf_counter tools: Guard against record damaging existing files

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index 23d1224..96bfb7c 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -340,7 +340,7 @@ static int __cmd_record(int argc, const char **argv)
 	assert(nr_cpus <= MAX_NR_CPUS);
 	assert(nr_cpus >= 0);
 
-	output = open(output_name, O_CREAT|O_RDWR, S_IRWXU);
+	output = open(output_name, O_CREAT|O_EXCL|O_RDWR, S_IRWXU);
 	if (output < 0) {
 		perror("failed to create output file");
 		exit(-1);
