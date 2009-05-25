Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbZEYMra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbZEYMra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZEYMrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:47:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:50254 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbZEYMrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:47:03 -0400
Date: Mon, 25 May 2009 12:45:35 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf stat: flip around ':k' and ':u' flags
Message-ID: <tip-d3f4b3855ba87caff8f35e738c7e7e3bad0a6ab1@git.kernel.org>
Git-Commit-ID: d3f4b3855ba87caff8f35e738c7e7e3bad0a6ab1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 12:45:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3f4b3855ba87caff8f35e738c7e7e3bad0a6ab1
Gitweb:     http://git.kernel.org/tip/d3f4b3855ba87caff8f35e738c7e7e3bad0a6ab1
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 25 May 2009 14:40:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 May 2009 14:40:01 +0200

perf stat: flip around ':k' and ':u' flags

This output:

 $ perf stat -e 0:1:k -e 0:1:u ./hello
  Performance counter stats for './hello':
          140131  instructions         (events)
         1906968  instructions         (events)

Is quite confusing - as :k means "user instructions", :u means
"kernel instructions".

Flip them around - as the 'exclude' property is not intuitive in
the flag naming.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-stat.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/perf_counter/builtin-stat.c b/Documentation/perf_counter/builtin-stat.c
index 8ae01d5..88c70be 100644
--- a/Documentation/perf_counter/builtin-stat.c
+++ b/Documentation/perf_counter/builtin-stat.c
@@ -266,9 +266,9 @@ static __u64 match_event_symbols(char *str)
 
 	switch (sscanf(str, "%d:%llu:%2s", &type, &id, mask_str)) {
 		case 3:
-			if (strchr(mask_str, 'u'))
-				event_mask[nr_counters] |= EVENT_MASK_USER;
 			if (strchr(mask_str, 'k'))
+				event_mask[nr_counters] |= EVENT_MASK_USER;
+			if (strchr(mask_str, 'u'))
 				event_mask[nr_counters] |= EVENT_MASK_KERNEL;
 		case 2:
 			return EID(type, id);
