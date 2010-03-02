Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab0CBOnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 09:43:24 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:43820 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab0CBOmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 09:42:38 -0500
From: Eric B Munson <ebmunson@us.ibm.com>
To: a.p.zijlstra@chello.nl
Cc: paulus@samba.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       Eric B Munson <ebmunson@us.ibm.com>
Subject: [PATCH 1/5] Add ID and STREAM_ID to recorded event data
Date: Tue,  2 Mar 2010 14:42:27 +0000
Message-Id: <71583fc64cb167adcdb0039b53b8bc76fed21f80.1267537676.git.ebmunson@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <cover.1267537676.git.ebmunson@us.ibm.com>
References: <cover.1267537676.git.ebmunson@us.ibm.com>
In-Reply-To: <cover.1267537676.git.ebmunson@us.ibm.com>
References: <cover.1267537676.git.ebmunson@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently perf record does not write the ID or the STREAM_ID to disk
for events.  This doesn't allow report to tell if an event stream contains
one or more types of events.  This patch adds these two entries to the list
of data that record will write to disk.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
---
 tools/perf/builtin-record.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 771533c..35e4605 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -242,7 +242,8 @@ static void create_counter(int counter, int cpu, pid_t pid)
 				  PERF_FORMAT_TOTAL_TIME_RUNNING |
 				  PERF_FORMAT_ID;
 
-	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID |
+				   PERF_SAMPLE_ID | PERF_SAMPLE_STREAM_ID;
 
 	if (freq) {
 		attr->sample_type	|= PERF_SAMPLE_PERIOD;
-- 
1.6.3.3

