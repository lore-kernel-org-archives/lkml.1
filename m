Return-Path: <linux-kernel-owner+w=401wt.eu-S1761047AbZE1PFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047AbZE1PFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbZE1PFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:05:03 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:59630 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbZE1PFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:05:01 -0400
Message-Id: <20090528150447.152019714@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 28 May 2009 17:04:47 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: [patch 0/2] NOHZ vs. profile/oprofile
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
Rob pointed me to a deficiency with the current profile/oprofile
code together with NOHZ. For us this problem crept in with the
conversion of s390 to generic clock events, git commit 5a62b192
If the system is running with the HZ-tick disabled and the cpu spents
time in idle we see skewed percentages e.g. with the oprofile output.
On an I/O bound system the number of idle ticks is way to small. The
reason is that the generic clock events code reports either zero or
one tick to profile/oprofile on wakeup from idle even if the cpu has
slept much longer.
I've tried to fix that with the two patches in this series and
another pure s390 specific fix (profile_tick is called from
clock_comparator_work which is nonsense). These three do correct the
oprofile output on s390. The best idea I had to get oprofile in good
shape again is to let the system tick at the HZ rate while oprofile
is working. Better ideas welcome.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

