Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbZIRMah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbZIRMah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 08:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZIRMaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 08:30:35 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:37863 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZIRMae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 08:30:34 -0400
Message-Id: <20090918122817.085266982@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 18 Sep 2009 14:28:17 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-arch@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>
Subject: [RFC resend][patch 0/1] nohz: introduce arch_needs_cpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
my first try with this patch did not draw any comment. So lets try
again, this time with linux-arch on CC.

I've been working on the cpu idle/wakeup path to improve the performance
of some ping-pong workloads. This patch is the latest idea and proved
rather effective. The idea is that the timer tick is not switched off
if the cpu did some work in the last tick period. This will add an
unnecessary tick interrupt if the cpu goes truly idle but will save
some cycles for the nohz reprogramming if the cpu wakes up again for
more work. For ping-pong like workload this is an overall win.

Currently only s390 has a non-zero arch_needs_cpu. It will be true if
there has been any other interrupt than timer interrupts in the last
tick period. I think this could be improved with an explicit call to
request a nohz delay. The call should be added to selective points in
the code, e.g. whenever a process != idle is scheduled, whenever a
bottom half is run, and so on. It works well enough on s390 as it is
though.

Does anyone have a problem with the patch? Otherwise I would like to
push it upstream as it gives us a nice improvement for s390.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.
