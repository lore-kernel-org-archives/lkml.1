Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbZHJMQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbZHJMQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbZHJMQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:16:26 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:40427 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbZHJMQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:16:25 -0400
Message-Id: <20090810121444.974476902@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Aug 2009 14:14:44 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>
Subject: [RFC][patch 0/1] nohz delay performance optimization
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
I'm still working on the cpu idle/wakeup path to improve the performance
of some ping-pong workloads. This patch is the latest idea and proved
rather effective. The idea is that the timer tick is not switched off
if the cpu did some work in the last tick period. This will add an
unnecessary tick interrupt if the cpu goes truly idle but will save
some cycles for the nohz reprogramming if the cpu wakes up again for
more work.

Currently the patch only works on s390, the arch_needs_cpu() will be
true if there has been any other interrupt than timer interrupts in the
last tick period. I think this could be improved with an explicit
call to request a nohz delay. The call should be added to selective
points in the code, e.g. whenever a process != idle is scheduled,
whenever a bottom half is run, and so on.

Comments?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

