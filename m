Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbYA2KkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbYA2KkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 05:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYA2KkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 05:40:08 -0500
Received: from nessie.weebeastie.net ([220.233.7.36]:52552 "EHLO
	bunyip.lochness.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752706AbYA2KkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 05:40:06 -0500
Date: Tue, 29 Jan 2008 21:37:39 +1100
From: AP <ap@zip.com.au>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: linux-kernel@vger.kernel.org, avi@qumranet.com, mingo@elte.hu
Subject: Re: [PATCH] documentation: Add desc of new cpu fields in /proc/stat
Message-ID: <20080129103738.GB4221@zip.com.au>
References: <20080129084352.GA4221@zip.com.au> <1201597516.4309.4.camel@frecb07144>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201597516.4309.4.camel@frecb07144>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 10:05:16AM +0100, Laurent Vivier wrote:
> Hi,
> 
> good thing, but could you update too "Table 1-3: Contents of the stat
> files" with fields added by 9ac52315d4cf5f561f36dabaf0720c00d3553162 .

Ok. Whilst in hiding from the grammar nazis, attempt #2 follows:

This patch syncs up the documentation for /proc/stat and /proc/<pid>/stat
with that of the changes made in 5e84cfde51cf303d368fcb48f22059f37b3872de
and 9ac52315d4cf5f561f36dabaf0720c00d3553162 respectively.

Signed-Off-By: Andrew P <ap@zip.com.au>

diff -aur linux/Documentation/filesystems/proc.txt work/Documentation/filesystems/proc.txt
--- linux/Documentation/filesystems/proc.txt	2008-01-29 11:27:18.000000000 +1100
+++ work/Documentation/filesystems/proc.txt	2008-01-29 21:30:59.000000000 +1100
@@ -192,7 +192,7 @@
 ..............................................................................
 
 
-Table 1-3: Contents of the stat files (as of 2.6.22-rc3)
+Table 1-3: Contents of the stat files (as of 2.6.24)
 ..............................................................................
  Field          Content
   pid           process id
@@ -237,6 +237,8 @@
   rt_priority   realtime priority
   policy        scheduling policy (man sched_setscheduler)
   blkio_ticks   time spent waiting for block IO
+  gtime         guest (virtual CPU) CPU time in jiffies
+  cgtime        guests' children's CPU time in jiffies
 ..............................................................................
 
 
@@ -813,9 +815,9 @@
 since the system first booted.  For a quick look, simply cat the file:
 
   > cat /proc/stat
-  cpu  2255 34 2290 22625563 6290 127 456 0
-  cpu0 1132 34 1441 11311718 3675 127 438 0
-  cpu1 1123 0 849 11313845 2614 0 18 0
+  cpu  2255 34 2290 22625563 6290 127 456 0 0
+  cpu0 1132 34 1441 11311718 3675 127 438 0 0
+  cpu1 1123 0 849 11313845 2614 0 18 0 0
   intr 114930548 113199788 3 0 5 263 0 4 [... lots more numbers ...]
   ctxt 1990473
   btime 1062191376
@@ -836,6 +838,7 @@
 - irq: servicing interrupts
 - softirq: servicing softirqs
 - steal: involuntary wait
+- guest: time used to run a virtual CPU
 
 The "intr" line gives counts of interrupts  serviced since boot time, for each
 of the  possible system interrupts.   The first  column  is the  total of  all

-- 
Andrew
