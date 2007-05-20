Return-Path: <linux-kernel-owner+w=401wt.eu-S1759709AbXETJh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759709AbXETJh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 05:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbXETJhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 05:37:15 -0400
Received: from mail23.syd.optusnet.com.au ([211.29.133.164]:35487 "EHLO
	mail23.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303AbXETJhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 05:37:14 -0400
From: Con Kolivas <kernel@kolivas.org>
To: ck list <ck@vds.kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] Staircase Deadline v1.00 cpu scheduler
Date: Sun, 20 May 2007 19:37:08 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 616
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200705201937.09328.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The staircase deadline cpu scheduler continues to be the reference with 
respect to interactive fairness for many workloads especially with 3d gaming. 
This version is only trivially different from the version included in the -ck 
patchset which has been very stable. The version number has been incremented 
to version 1.00 purely to reflect that stability. Those on -ck are already 
running the equivalent of this version.

http://www.kernel.org/pub/linux/kernel/people/ck/patches/staircase-deadline/2.6.22-rc2/2.6.22-rc2-sd-1.00.patch

In comparison with the standalone version 0.48 of sd the changes are as 
follows:

Default rr_interval was increased to 10ms on uniprocessor (it is scaled up on 
SMP) for throughput reasons. Note that -ck has 6ms and -cks has 10ms as 
defaults (on UP, double that for 2 cpus). This can be altered (as always) by 
modifying the value in /proc/sys/kernel/rr_interval.

The PRIO value exported to userspace as seen by 'top', 'ps' etc will now 
reflect the relative priority of tasks on the expired array by their value 
being greater than 39.

The interactive tunable patch was rolled into this patch and is enabled by 
default. Note the effect of this tunable is subtle except on 3d games. This 
can be altered by modifying /proc/sys/kernel/interactive. A summary of the 
interactive sysctl from Documentation/sysctl/kernel is:

The staircase-deadline cpu scheduler can be set in either purely
forward-looking mode for absolutely rigid fairness and cpu distribution
according to nice level, or it can allow a small per-process history
to smooth out cpu usage perturbations common in interactive tasks by
enabling this sysctl. While small fairness issues can arise with this
enabled, overall fairness is usually still strongly maintained and
starvation is never possible. Enabling this can significantly smooth
out 3d graphics and games.

-- 
-ck
