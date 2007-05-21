Return-Path: <linux-kernel-owner+w=401wt.eu-S934889AbXEUUJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934889AbXEUUJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759560AbXEUUI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:08:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50573 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761217AbXEUUI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:08:57 -0400
Date: Mon, 21 May 2007 15:08:56 -0500
To: linux-kernel@vger.kernel.org
Subject: hotplug cpu: PATCHes for 3 issues
Message-ID: <4651FC58.mailxOW91VRGMT@eag09.americas.sgi.com>
User-Agent: nail 11.4 8/29/04
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: cpw@sgi.com (Cliff Wickman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



In the 2.6.21 kernel there are still 3 hotplug issues that are cpuset-
related, and that I find to still be problems.   And for which I offer
patches.

These have been submitted before, and subsequently cleaned up per
comments received.  I'm resubmitting all 3 for consideration and further
comment.

1)  [PATCH 1/1] hotplug cpu: cpusets/sched_domain reconciliation
2)  [PATCH 1/1] hotplug cpu: move tasks in empty cpusets to parent
3)  [PATCH 1/1] hotplug cpu: migrate a task within its cpuset

1) Reconciles cpusets and sched_domains that get out of sync
   due to hotplug disabling and re-enabling of cpu's.
   Tasks can get into infinite hangs without this fix.
     kernel/cpuset.c
     kernel/sched.c 

2) When a cpuset is emptied by disabling its cpus, move tasks to 
   a parent cpuset.
   This is a correction of the current procedure, which moves such
   tasks to the wrong cpuset.
     kernel/cpuset.c

3) Causes a task running on a disabled cpu to migrate to a cpu within
   its cpuset.
   This behavior is particularly important for a NUMA system on which
   tasks have been explicitly placed.
     kernel/sched.c
