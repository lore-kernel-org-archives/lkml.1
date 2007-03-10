Return-Path: <linux-kernel-owner+w=401wt.eu-S933516AbXCJHYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516AbXCJHYZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 02:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933515AbXCJHYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 02:24:25 -0500
Received: from mail04.syd.optusnet.com.au ([211.29.132.185]:42271 "EHLO
	mail04.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933516AbXCJHYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 02:24:22 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][RSDL-mm 0/6]  Rotating Staircase DeadLine scheduler for -mm
Date: Sat, 10 Mar 2007 18:25:12 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1914
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703101825.13015.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What follows this email is a series of patches for the RSDL cpu scheduler as 
found in 2.6.21-rc3-mm1. This series is for 2.6.21-rc3-mm2 and has some 
bugfixes for the issues found so far. While it is not clear that I've 
attended to all the bugs, it is worth noting that a complete rewrite is a 
teensy bit more than a trivial change shall we say ;)

akpm it still has trouble on that monster config of yours but there's so much 
else going on in this -mm I don't know what to make of it. getting ppc to work 
on qemu was more work than I thought and I haven't succeeded there yet 
either :|

A rolled up patch can be found here:
http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2-rsdl.patch

Patch series here:
http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2/

and the patch series will follow. If time permits I will make available a 
newer version for the older kernels soon.

Changelog:
- Made it possible for the idle task to schedule on cpu_hotplug.
- Fixed the accounting across fork()
- Recalculation of priority for tasks that have already run this major 
rotation and are now on the expired array was wrong. It has been corrected.
- The bitmap error that has been hit on some architectures was made more 
verbose to make it clear that something has gone wrong, and will keep going 
off if the problem persists.

-- 
-ck
