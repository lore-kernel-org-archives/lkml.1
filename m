Return-Path: <linux-kernel-owner+w=401wt.eu-S936244AbYEVKHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936244AbYEVKHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935033AbYEVKGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:06:46 -0400
Received: from ns.miraclelinux.com ([219.118.163.66]:38725 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934669AbYEVKGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:06:45 -0400
Message-ID: <48354470.60403@miraclelinux.com>
Date: Thu, 22 May 2008 19:01:20 +0900
From: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>
Subject: [RFC][PATCH 1/2 v2] MAZE: Documentation/maze.txt
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2008.5.22.24453
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
---
 Documentation/maze.txt |  103 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.26-rc2-mm1/Documentation/maze.txt	2008-05-22 10:23:10.000000000 +0900
@@ -0,0 +1,103 @@
+				MAZE
+				----
+Written by Hirofumi Nakagawa <hnakagawa@miraclelinux.com> based
+on Documentation/cpusets.txt and Documentation/cgroups.txt
+
+Original copyright statements from cpusets.txt:
+Portions Copyright (C) 2004 BULL SA.
+Portions Copyright (c) 2004-2006 Silicon Graphics, Inc.
+
+CONTENTS:
+=========
+
+1. MAZE
+  1.1 What is MAZE ?
+  1.2 Why is MAZE needed ?
+  1.3 What is the difference between MAZE and rlimit ?
+2. Usage Examples
+  2.1 Adding watch task
+  2.2 Getting watch task list
+
+1. MAZE
+=================
+
+1.1 What is MAZE ?
+----------------------
+
+MAZE provides a mechanism for detecting excessive CPU cycle usage of
+selected processes and sending signals to them.
+
+The definition of excessive CPU cycle usage is staying in TASK_RUNNINT
+state for a long time.
+Normally, a working process doesn't stay long time in TASK_RUNNING state
+because of occasional IO waits or calling sleeps.
+MAZE detects excessive CPU cycle usage from process's information and sends
+signal when time of staying in TASK_RUNNING exceeds user defined limits.
+
+The aim is to implement a CGL (Carrier Grade Linux) requirement (AVL.14.0).
+
+Quote
+from CGL specification:
+(http://developer.osdl.org/dev/cgl/cgl40/cgl40-availability.pdf)
+
+OSDL CGL specifies that carrier grade Linux shall provide a
+mechanism that detects excessive CPU cycle usage by any process or thread.
+To enable detection, the following capabilities shall be provided:
+ - Communication between the monitoring process and the kernel.
+ - Registering a list of processes or threads and their allowed CPU cycle
+   thresholds.
+ - Ability to define policy based on process events including process/thread
+   creation and exit.
+ - Ability to take action whenever an event occurs.
+ - Ability to set the CPU cycle threshold to a resolution of one millisecond.
+
+
+1.2 Why is MAZE needed ?
+----------------------
+
+MAZE can improve availability of a system.
+An unexpected excessive CPU cycle usage does affect the system.
+It is serious, especially in systems with tight resouce such as embedded.
+MAZE can detect such processes, kill or notify them.
+
+1.3 What is the difference between MAZE and rlimit(RLIMIT_CPU) ?
+----------------------
+
+The differences with MAZE and rlimit are as follows.
+ - MAZE detects excessive CPU cycle usage, but rlimits limits total amount
+   of CPU usage.
+   MAZE can safely handle CPU intensive but correctly running processes.
+
+ - User processes can add watched processes in MAZE.
+
+ - MAZE allows users to choose a way how to act on the process,
+   sending a selected signal.
+
+2. Usage Examples
+=================
+
+2.1 Adding watch task
+----------------------
+
+Adding a task to watch.
+
+# echo "[PID] [Soft limit] [Hard limit] [Soft signal] [Hard signal]" > \
+  /proc/maze/entries
+
+The numeric values are "pid","soft limit [msec]","hard limit [msec]",
+"soft signal" and "hard signal".
+
+For example,
+
+# echo "2206 15000 30000 24 9" > /proc/maze/entries
+
+2.2 Getting watch task list.
+----------------------
+
+Getting registed task list.
+
+# cat /proc/maze/entries
+pid:2209 count:   0 soft-limit:15000 hard-limit:30000 soft-signal: 24 hard-signal: 9
+pid:2207 count:   0 soft-limit:15000 hard-limit:30000 soft-signal: 24 hard-signal: 9
+pid:2206 count: 100 soft-limit:15000 hard-limit:30000 soft-signal: 24 hard-signal: 9
+








