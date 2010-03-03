Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab0CCPik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:38:40 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:62932 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab0CCPij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:38:39 -0500
From: Eric B Munson <ebmunson@us.ibm.com>
To: a.p.zijlstra@chello.nl
Cc: paulus@samba.org, mingo@elte.hu, acme@redhat.com,
       linux-kernel@vger.kernel.org, Eric B Munson <ebmunson@us.ibm.com>
Subject: [PATCH 1/5] Add ID and to recorded event data when recording multiple events
Date: Wed,  3 Mar 2010 15:38:23 +0000
Message-Id: <a7748dd31ffa35cdd06bb64cadbac2115bb50fb2.1267630395.git.ebmunson@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <cover.1267630395.git.ebmunson@us.ibm.com>
References: <cover.1267630395.git.ebmunson@us.ibm.com>
In-Reply-To: <cover.1267630395.git.ebmunson@us.ibm.com>
References: <cover.1267630395.git.ebmunson@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently perf record does not write the ID or the to disk for events.
This doesn't allow report to tell if an event stream contains one or
more types of events.  This patch adds this entry to the list of data
that record will write to disk if more than one event was requested.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
---
 tools/perf/builtin-record.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 771533c..f573bbb 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -244,6 +244,9 @@ static void create_counter(int counter, int cpu, pid_t pid)
 
 	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
+	if (nr_counters > 1)
+		attr->sample_type |= PERF_SAMPLE_ID;
+
 	if (freq) {
 		attr->sample_type	|= PERF_SAMPLE_PERIOD;
 		attr->freq		= 1;
-- 
1.6.3.3

