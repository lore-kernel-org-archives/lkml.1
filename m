Return-Path: <linux-kernel-owner+w=401wt.eu-S1758541AbZIOTPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541AbZIOTPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758582AbZIOTPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:15:36 -0400
Received: from kroah.org ([198.145.64.141]:33079 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758541AbZIOTPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:15:08 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: GeunSik Lim <leemgs1@gmail.com>, GeunSik Lim <geunsik.lim@samsung.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/20] debugfs: Fix mount directory of debugfs by default in events.txt
Date: Tue, 15 Sep 2009 12:12:51 -0700
Message-Id: <1253041976-1111-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090915181247.GA32167@kroah.com>
References: <20090915181247.GA32167@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GeunSik Lim <leemgs1@gmail.com>

We need common default directory of denbugfs for consistency.
(debugfs's default directory is /sys/kernel/debug/ by debugfs.)

Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/trace/events.txt |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index 2bcc8d4..90e8b33 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -22,12 +22,12 @@ tracing information should be printed.
 ---------------------------------
 
 The events which are available for tracing can be found in the file
-/debug/tracing/available_events.
+/sys/kernel/debug/tracing/available_events.
 
 To enable a particular event, such as 'sched_wakeup', simply echo it
-to /debug/tracing/set_event. For example:
+to /sys/kernel/debug/tracing/set_event. For example:
 
-	# echo sched_wakeup >> /debug/tracing/set_event
+	# echo sched_wakeup >> /sys/kernel/debug/tracing/set_event
 
 [ Note: '>>' is necessary, otherwise it will firstly disable
   all the events. ]
@@ -35,15 +35,15 @@ to /debug/tracing/set_event. For example:
 To disable an event, echo the event name to the set_event file prefixed
 with an exclamation point:
 
-	# echo '!sched_wakeup' >> /debug/tracing/set_event
+	# echo '!sched_wakeup' >> /sys/kernel/debug/tracing/set_event
 
 To disable all events, echo an empty line to the set_event file:
 
-	# echo > /debug/tracing/set_event
+	# echo > /sys/kernel/debug/tracing/set_event
 
 To enable all events, echo '*:*' or '*:' to the set_event file:
 
-	# echo *:* > /debug/tracing/set_event
+	# echo *:* > /sys/kernel/debug/tracing/set_event
 
 The events are organized into subsystems, such as ext4, irq, sched,
 etc., and a full event name looks like this: <subsystem>:<event>.  The
@@ -52,29 +52,29 @@ file.  All of the events in a subsystem can be specified via the syntax
 "<subsystem>:*"; for example, to enable all irq events, you can use the
 command:
 
-	# echo 'irq:*' > /debug/tracing/set_event
+	# echo 'irq:*' > /sys/kernel/debug/tracing/set_event
 
 2.2 Via the 'enable' toggle
 ---------------------------
 
-The events available are also listed in /debug/tracing/events/ hierarchy
+The events available are also listed in /sys/kernel/debug/tracing/events/ hierarchy
 of directories.
 
 To enable event 'sched_wakeup':
 
-	# echo 1 > /debug/tracing/events/sched/sched_wakeup/enable
+	# echo 1 > /sys/kernel/debug/tracing/events/sched/sched_wakeup/enable
 
 To disable it:
 
-	# echo 0 > /debug/tracing/events/sched/sched_wakeup/enable
+	# echo 0 > /sys/kernel/debug/tracing/events/sched/sched_wakeup/enable
 
 To enable all events in sched subsystem:
 
-	# echo 1 > /debug/tracing/events/sched/enable
+	# echo 1 > /sys/kernel/debug/tracing/events/sched/enable
 
 To eanble all events:
 
-	# echo 1 > /debug/tracing/events/enable
+	# echo 1 > /sys/kernel/debug/tracing/events/enable
 
 When reading one of these enable files, there are four results:
 
-- 
1.6.4.2

