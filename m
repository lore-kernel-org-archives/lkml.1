Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbZL1KJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbZL1KJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbZL1KIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:08:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:36309 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbZL1KIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:08:52 -0500
Date: Mon, 28 Dec 2009 10:07:00 GMT
From: tip-bot for Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, tim@klingt.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       tim@klingt.org, mingo@elte.hu
In-Reply-To: <4B37646A.90108@klingt.org>
References: <4B37646A.90108@klingt.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Rename perf_event_hw_event in design document
Message-ID: <tip-0b413e44d64aeac36a096505a40fc2ff470872fa@git.kernel.org>
Git-Commit-ID: 0b413e44d64aeac36a096505a40fc2ff470872fa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b413e44d64aeac36a096505a40fc2ff470872fa
Gitweb:     http://git.kernel.org/tip/0b413e44d64aeac36a096505a40fc2ff470872fa
Author:     Tim Blechmann <tim@klingt.org>
AuthorDate: Sun, 27 Dec 2009 14:43:06 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Dec 2009 09:14:37 +0100

perf: Rename perf_event_hw_event in design document

perf_event_hw_event has been renamed to perf_event_attr. The
design document was still using the old name, though.

Signed-off-by: Tim Blechmann <tim@klingt.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B37646A.90108@klingt.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/design.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index f000c30..8d0de51 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -21,7 +21,7 @@ There's one file descriptor per virtual counter used.
 The special file descriptor is opened via the perf_event_open()
 system call:
 
-   int sys_perf_event_open(struct perf_event_hw_event *hw_event_uptr,
+   int sys_perf_event_open(struct perf_event_attr *hw_event_uptr,
 			     pid_t pid, int cpu, int group_fd,
 			     unsigned long flags);
 
@@ -32,9 +32,9 @@ can be used to set the blocking mode, etc.
 Multiple counters can be kept open at a time, and the counters
 can be poll()ed.
 
-When creating a new counter fd, 'perf_event_hw_event' is:
+When creating a new counter fd, 'perf_event_attr' is:
 
-struct perf_event_hw_event {
+struct perf_event_attr {
         /*
          * The MSB of the config word signifies if the rest contains cpu
          * specific (raw) counter configuration data, if unset, the next
@@ -399,7 +399,7 @@ Notification of new events is possible through poll()/select()/epoll() and
 fcntl() managing signals.
 
 Normally a notification is generated for every page filled, however one can
-additionally set perf_event_hw_event.wakeup_events to generate one every
+additionally set perf_event_attr.wakeup_events to generate one every
 so many counter overflow events.
 
 Future work will include a splice() interface to the ring-buffer.
