Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbZHUThe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbZHUThe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 15:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbZHUThd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 15:37:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:41980 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458AbZHUThb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 15:37:31 -0400
Date: Fri, 21 Aug 2009 19:36:34 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, eranian@googlemail.com, cjashfor@us.ibm.com,
       a.p.zijlstra@chello.nl, perfmon2-devel@lists.sourceforge.net,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, eranian@googlemail.com,
       a.p.zijlstra@chello.nl, cjashfor@us.ibm.com,
       perfmon2-devel@lists.sourceforge.net, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1250867976.7538.73.camel@twins>
References: <1250867976.7538.73.camel@twins>
Subject: [tip:perfcounters/urgent] perf_counter: Fix typo in read() output generation
Message-ID: <tip-4464fcaa9cbfc9c551956b48af203e2f775ca892@git.kernel.org>
Git-Commit-ID: 4464fcaa9cbfc9c551956b48af203e2f775ca892
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 21 Aug 2009 19:36:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4464fcaa9cbfc9c551956b48af203e2f775ca892
Gitweb:     http://git.kernel.org/tip/4464fcaa9cbfc9c551956b48af203e2f775ca892
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 21 Aug 2009 17:19:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 Aug 2009 18:00:35 +0200

perf_counter: Fix typo in read() output generation

When you iterate a list, using the iterator is useful.

Before:

   ID: 5
   ID: 5
   ID: 5
   ID: 5
   EVNT: 0x40088b scale: nan ID: 5 CNT: 1006252 ID: 6 CNT: 1011090 ID: 7 CNT: 1011196 ID: 8 CNT: 1011095
   EVNT: 0x40088c scale: 1.000000 ID: 5 CNT: 2003065 ID: 6 CNT: 2011671 ID: 7 CNT: 2012620 ID: 8 CNT: 2013479
   EVNT: 0x40088c scale: 1.000000 ID: 5 CNT: 3002390 ID: 6 CNT: 3015996 ID: 7 CNT: 3018019 ID: 8 CNT: 3020006
   EVNT: 0x40088b scale: 1.000000 ID: 5 CNT: 4002406 ID: 6 CNT: 4021120 ID: 7 CNT: 4024241 ID: 8 CNT: 4027059

After:

   ID: 1
   ID: 2
   ID: 3
   ID: 4
   EVNT: 0x400889 scale: nan ID: 1 CNT: 1005270 ID: 2 CNT: 1009833 ID: 3 CNT: 1010065 ID: 4 CNT: 1010088
   EVNT: 0x400898 scale: nan ID: 1 CNT: 2001531 ID: 2 CNT: 2022309 ID: 3 CNT: 2022470 ID: 4 CNT: 2022627
   EVNT: 0x400888 scale: 0.489467 ID: 1 CNT: 3001261 ID: 2 CNT: 3027088 ID: 3 CNT: 3027941 ID: 4 CNT: 3028762

Reported-by: stephane eranian <eranian@googlemail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey J Ashford <cjashfor@us.ibm.com>
Cc: perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
LKML-Reference: <1250867976.7538.73.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 36f65e2..f274e19 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1791,7 +1791,7 @@ static int perf_counter_read_group(struct perf_counter *counter,
 	size += err;
 
 	list_for_each_entry(sub, &leader->sibling_list, list_entry) {
-		err = perf_counter_read_entry(counter, read_format,
+		err = perf_counter_read_entry(sub, read_format,
 				buf + size);
 		if (err < 0)
 			return err;
