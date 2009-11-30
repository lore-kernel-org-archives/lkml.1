Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbZK3LQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbZK3LQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbZK3LQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:16:49 -0500
Received: from mtagate6.de.ibm.com ([195.212.17.166]:48052 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbZK3LQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:16:43 -0500
From: ehrhardt@linux.vnet.ibm.com
To: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: ehrhardt@linux.vnet.ibm.com, Holger.Wolf@de.ibm.com, epasch@de.ibm.com,
       schwidefsky@de.ibm.com
Subject: [PATCH 0/3] fix rescaling of scheduler tunables v2
Date: Mon, 30 Nov 2009 12:16:45 +0100
Message-Id: <1259579808-11357-1-git-send-email-ehrhardt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*updates in v2*
Some testing later v2 has a fix and a few minor changes
- changes of the scaling type update the normalized values according
  to the new factor
- minor fixes to satisfy checkpatch.pl
-> ready for discussion and/or acceptance now :-) 

This patch series is based on the ideas of Peter Zijlstra and me in the
discussion how to fix missing updates to the scheduler tunables in case
of cpu hot add/remove. The values are scaled on boot time but not (yet)
in the runtime #cpu changes.

Series contains:
[PATCH 1/3] sched: fix missing sched tunable recalculation on cpu add/remove
[PATCH 2/3] sched: make tunable scaling style configurable
[PATCH 3/3] sched: update normalized values on user updates via proc v2

[diffstat]
 kernel/sched.c                                  |   41 ++++++++++++++----------
 kernel/sched_fair.c                             |   27 +++++++++++++++
 kernel/sysctl.c                                 |   14 +++++---
 linux-2.6-git-schedrecalc/include/linux/sched.h |   10 +++++
 linux-2.6-git-schedrecalc/kernel/sched.c        |   15 ++++++++
 linux-2.6-git-schedrecalc/kernel/sched_debug.c  |   10 +++++
 linux-2.6-git-schedrecalc/kernel/sched_fair.c   |   13 +++++++
 linux-2.6-git-schedrecalc/kernel/sysctl.c       |   14 ++++++++
 8 files changed, 121 insertions(+), 23 deletions(-)
