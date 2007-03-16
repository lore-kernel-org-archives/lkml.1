Return-Path: <linux-kernel-owner+w=401wt.eu-S933751AbXCPNtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751AbXCPNtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 09:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933757AbXCPNtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 09:49:18 -0400
Received: from mail31.syd.optusnet.com.au ([211.29.132.102]:48181 "EHLO
	mail31.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933751AbXCPNtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 09:49:18 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][RSDL-mm 0/6] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Sat, 17 Mar 2007 00:50:28 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1914
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703170050.28510.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What follows is a patch series for the updated version of the Rotating 
Staircase DeadLine cpu scheduler.

The dropping of one patch in the series and modest rewrite of certain 
components means a fresh patch series is most appropriate, apologies for any 
inconvenience.


Changes

- Implemented the dithered priority slot bitmap which makes latencies between 
differential nice levels much smaller, allowing X to be run nice -n -10 for 
example.

- Dropped back to 140 bit bitmap. The expired bitmap became a necessity with 
the more complex priority matrix.

- Removed the static priority accounting. It wasn't being used for anything.

- Simplified the preempt check to correspond with the changed priority system.

- Made the rr interval slightly larger at 8ms, and to scale gently with rise 
in number of cpus. At 8ms it will round up to 10ms on 250HZ, whereas 
selecting 1000HZ by the user implies latency is more relevant and they will 
get the 8ms. The larger rr interval should decrease context switches and 
cache trashing. It would be quite easy to simply make this a meaningful 
tunable in /proc.

- Fixed a bug that was resetting priority in normal_prio() on wakeup

- Fixed a problem whereby new quota was not being set on reniced tasks until 
they had slept.

- Updated the documentation to match changed design.

- Lots of painkillers and rest

-- 
-ck
