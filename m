Return-Path: <linux-kernel-owner+w=401wt.eu-S1752034AbZIIKxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbZIIKxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 06:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZIIKxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 06:53:30 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:43031 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbZIIKxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 06:53:30 -0400
Message-ID: <4AA78926.9030001@gmail.com>
Date: Wed, 09 Sep 2009 12:53:26 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] proc: Documents guest column in /proc/stat
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 09 Sep 2009 12:53:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We added a new column in cpuX lines of /proc/stat, to show
the amount of time spent by a cpu servicing a guest, without
updating Documentation/filesystems/proc.txt

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index ffead13..1c96cb6 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1032,9 +1032,9 @@ Various pieces   of  information about  kernel activity  are  available in the
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
@@ -1056,6 +1056,7 @@ second).  The meanings of the columns are as follows, from left to right:
 - irq: servicing interrupts
 - softirq: servicing softirqs
 - steal: involuntary wait
+- guest: running a guest
 
 The "intr" line gives counts of interrupts  serviced since boot time, for each
 of the  possible system interrupts.   The first  column  is the  total of  all

