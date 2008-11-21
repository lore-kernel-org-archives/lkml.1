Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYKUEBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYKUEBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 23:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYKUEB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 23:01:27 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:39539 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbYKUEB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 23:01:27 -0500
Date: Thu, 20 Nov 2008 20:01:28 -0800
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: h-shimamoto@ct.jp.nec.com
Subject: [PATCH 3/3] proc: Update document for /proc/softirqs and /proc/stat
Message-Id: <20081120200128.a853ffc6.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20081120195542.c85d4967.kobayashi.kk@ncos.nec.co.jp>
References: <20081120195542.c85d4967.kobayashi.kk@ncos.nec.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/softirqs and /proc/stat have been changed.
This patch updates proc.txt for these usage.

Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Reviewed-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 Documentation/filesystems/proc.txt |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index bcceb99..ef1eeae 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -288,6 +288,7 @@ Table 1-4: Kernel info in /proc
  rtc         Real time clock                                   
  scsi        SCSI info (see text)                              
  slabinfo    Slab pool info                                    
+ softirqs    softirq usage
  stat        Overall statistics                                
  swaps       Swap space utilization                            
  sys         See chapter 2                                     
@@ -602,6 +603,24 @@ on the kind of area :
 0xffffffffa0017000-0xffffffffa0022000   45056 sys_init_module+0xc27/0x1d00 ...
    pages=10 vmalloc N0=10
 
+..............................................................................
+
+softirqs:
+
+Provides counts of softirq handlers serviced since boot time, for each cpu.
+
+> cat /proc/softirqs
+                CPU0       CPU1       CPU2       CPU3
+HI                 0          0          0          0
+TIMER          27166      27120      27097      27034
+NET_TX             0          0          0         17
+NET_RX            42          0          0         39
+BLOCK              0          0        107       1121
+TASKLET            0          0          0        290
+SCHED          27035      26983      26971      26746
+RCU             1678       1769       2178       2250
+
+
 1.3 IDE devices in /proc/ide
 ----------------------------
 
@@ -888,6 +907,7 @@ since the system first booted.  For a quick look, simply cat the file:
   processes 2915
   procs_running 1
   procs_blocked 0
+  softirq 183433 0 21755 12 39 1137 231 21459 2263
 
 The very first  "cpu" line aggregates the  numbers in all  of the other "cpuN"
 lines.  These numbers identify the amount of time the CPU has spent performing
@@ -923,6 +943,11 @@ CPUs.
 The   "procs_blocked" line gives  the  number of  processes currently blocked,
 waiting for I/O to complete.
 
+The "softirq" line gives counts of softirqs serviced since boot time, for each
+of the possible system softirqs. The first column is the total of all
+softirqs serviced; each subsequent column is the total for that particular
+softirq.
+
 
 1.9 Ext4 file system parameters
 ------------------------------
-- 
1.5.0.6

