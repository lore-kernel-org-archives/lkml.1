Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407Ab0ANRn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab0ANRn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 12:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389Ab0ANRnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 12:43:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab0ANRny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 12:43:54 -0500
Date: Thu, 14 Jan 2010 12:43:20 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <201001141743.o0EHhKUV023427@hs20-bc2-1.build.redhat.com>
To: a.p.zijlstra@chello.nl, acme@redhat.com, eranian@google.com,
       fweisbec@gmail.com, linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       mingo@elte.hu, paulus@samba.org
Subject: perf: don't use obsolete getpagesize
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf uses the obsolete getpagesize function.  Let's do better and use the
correct POSIX interface to get the information: sysconf.


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index b557b83..cc8b396 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -153,7 +153,7 @@ int perf_session__process_events(struct perf_session *self,
 
 	perf_event_ops__fill_defaults(ops);
 
-	page_size = getpagesize();
+	page_size = sysconf(_SC_PAGESIZE);
 
 	head = self->header.data_offset;
 	self->sample_type = perf_header__sample_type(&self->header);
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index cace355..948dc9e 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -533,7 +533,7 @@ int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
 	write_or_die(buf, 1);
 
 	/* save page_size */
-	page_size = getpagesize();
+	page_size = sysconf(_SC_PAGESIZE);
 	write_or_die(&page_size, 4);
 
 	read_header_files();
