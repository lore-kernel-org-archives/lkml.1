Return-Path: <linux-kernel-owner+w=401wt.eu-S932202AbZISJwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbZISJwq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757012AbZISJwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:52:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:57107 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756402AbZISJwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:52:44 -0400
Date: Sat, 19 Sep 2009 09:52:19 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, arjan@linux.intel.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090912130511.411434b5@infradead.org>
References: <20090912130511.411434b5@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf: Add a sample_event type to the event_union
Message-ID: <tip-fd39e055c4fefa4553efc9030f9903afdc6ee323@git.kernel.org>
Git-Commit-ID: fd39e055c4fefa4553efc9030f9903afdc6ee323
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 09:52:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd39e055c4fefa4553efc9030f9903afdc6ee323
Gitweb:     http://git.kernel.org/tip/fd39e055c4fefa4553efc9030f9903afdc6ee323
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Sat, 12 Sep 2009 07:53:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 11:42:12 +0200

perf: Add a sample_event type to the event_union

Add a sample_event type to the event_union so that raw samples can
be processed easily.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20090912130511.411434b5@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/event.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 28a579f..018d414 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -60,6 +60,12 @@ struct read_event {
 	u64 id;
 };
 
+struct sample_event{
+	struct perf_event_header        header;
+	u64 array[];
+};
+
+
 typedef union event_union {
 	struct perf_event_header	header;
 	struct ip_event			ip;
@@ -68,6 +74,7 @@ typedef union event_union {
 	struct fork_event		fork;
 	struct lost_event		lost;
 	struct read_event		read;
+	struct sample_event		sample;
 } event_t;
 
 struct map {
