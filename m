Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbXEYNNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbXEYNNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 09:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760492AbXEYNNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 09:13:14 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:54006 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbXEYNNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 09:13:13 -0400
Message-ID: <4656E0D7.1090301@hitachi.com>
Date: Fri, 25 May 2007 22:12:55 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, holt@sgi.com, alan@lxorguk.ukuu.org.uk,
       masami.hiramatsu.pt@hitachi.com, yumiko.sugita.yf@hitachi.com,
       soshima@redhat.com, haoki@redhat.com
Subject: [PATCH 7/7] documentation for /proc/pid/coredump_filter
References: <4656DBFB.2050501@hitachi.com>
In-Reply-To: <4656DBFB.2050501@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the documentation for /proc/<pid>/coredump_filter.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 Documentation/filesystems/proc.txt |   38 +++++++++++++++++++++++++++
 1 files changed, 38 insertions(+)

Index: linux-2.6.22-rc2-mm1/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.22-rc2-mm1.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.22-rc2-mm1/Documentation/filesystems/proc.txt
@@ -42,6 +42,7 @@ Table of Contents
   2.12	/proc/<pid>/oom_adj - Adjust the oom-killer score
   2.13	/proc/<pid>/oom_score - Display current oom-killer score
   2.14	/proc/<pid>/io - Display the IO accounting fields
+  2.15	/proc/<pid>/coredump_filter - Core dump filtering settings
 
 ------------------------------------------------------------------------------
 Preface
@@ -2135,4 +2136,41 @@ those 64-bit counters, process A could s
 More information about this can be found within the taskstats documentation in
 Documentation/accounting.
 
+2.15 /proc/<pid>/coredump_filter - Core dump filtering settings
+---------------------------------------------------------------
+When a process is dumped, all anonymous memory is written to a core file as
+long as the size of the core file isn't limited. But sometimes we don't want
+to dump some memory segments, for example, huge shared memory. Conversely,
+sometimes we wnat to save file-backed memory segments into a core file, not
+only the individual files.
+
+/proc/<pid>/coredump_filter allows you to customize which memory segments
+will be dumped when the <pid> process is dumped. coredump_filter is a bitmask
+of memory types. If a bit of the bitmask is set, memory segments of the
+corresponding memory type are dumped, otherwise they are not dumped.
+
+The following 4 memory types are supported:
+  - (bit 0) anonymous private memory
+  - (bit 1) anonymous shared memory
+  - (bit 2) file-backed private memory
+  - (bit 3) file-backed shared memory
+
+  Note that MMIO pages such as frame buffer are never dumped and vDSO pages
+  are always dumped regardless of the bitmask status.
+
+Default value of coredump_filter is 0x3; this means all anonymous memory
+segments are dumped.
+
+If you don't want to dump all shared memory segments attached to pid 1234,
+write 1 to the process's proc file.
+
+  $ echo 0x1 > /proc/1234/coredump_filter
+
+When a new process is created, the process inherits the bitmask status from its
+parent. It is useful to set up coredump_filter before the program runs.
+For example:
+
+  $ echo 0x7 > /proc/self/coredump_filter
+  $ ./some_program
+
 ------------------------------------------------------------------------------


