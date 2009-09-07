Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbZIGMha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbZIGMha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 08:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZIGMh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 08:37:28 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:2373 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbZIGMhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 08:37:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HOAl1+QDa2LEXCKlcbMM4jputGZXEC9ojKITHnnWmlI8XkA/GvmX+toZLpwob3V5OJ
         VjY12iRzK/Z4GjqF8zpNRQejdeeCegGkSlJmDPL7Q2gA30oy7NWxDYc4LeXpDF5yhu8s
         cltO0+r7ERzbClv9Ltr/zJATD/b1K5hTcmUwQ=
Subject: [PATCH 1/5] debugfs - Fix mount directory of debugfs by default in
	events.txt
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, mathieu.desnoyers@polymtl.ca
Content-Type: text/plain
Organization: Private
Date: Mon, 07 Sep 2009 21:37:17 +0900
Message-Id: <1252327037.2153.96.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>From 99e8ab48d783e619329c31e8f91e4384729a2e8b Mon Sep 17 00:00:00 2001
From: GeunSik,Lim <leemgs1@gmail.com>
Date: Mon, 7 Sep 2009 20:34:19 +0900
Subject: [PATCH 1/5] Fix mount directory of debugfs by default in events.txt

We need common default directory of denbugfs for consistency.
(debugfs's default directory is /sys/kernel/debug/ by debugfs.)

	Signed-Off-By:GeunSik Lim <geunsik.lim@samsung.com>
---
 Documentation/trace/events.txt |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index f157d75..3b72823 100644
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
1.6.3.1


-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim ( Samsung Electronics )
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://blog.naver.com/invain/
-----------------------------------------------

