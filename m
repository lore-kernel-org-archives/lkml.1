Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbZLQS6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbZLQS6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbZLQS6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:58:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:60914 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZLQS6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:58:51 -0500
Message-Id: <20091217185021.684424629@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 17 Dec 2009 19:50:21 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/6] Some load-balancer cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since RT has since grown its own load-balancer which is totally independent
from CFS, we can remove some of the left-overs from back when.

Gets rid of the ->load_balance and ->move_one_task sched_class calls and
removed the rq_iterator stuff.

Also carries a lock-break recently found wanted by -rt.

Compile tested with CGROUP/SMP/UP and booted on x86_64-SMP.

 include/linux/sched.h   |    8 -
 kernel/sched.c          | 1945 ++---------------------------------------------
 kernel/sched_fair.c     | 1778 +++++++++++++++++++++++++++++++++++++++++--
 kernel/sched_idletask.c |   21 -
 kernel/sched_rt.c       |   20 -
 5 files changed, 1805 insertions(+), 1967 deletions(-)


