Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbZK0Opw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbZK0Opw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbZK0Opv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 09:45:51 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:59195 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZK0Opv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 09:45:51 -0500
From: ehrhardt@linux.vnet.ibm.com
To: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: ehrhardt@linux.vnet.ibm.com, Holger.Wolf@de.ibm.com, epasch@de.ibm.com,
       schwidefsky@de.ibm.com
Subject: [PATCH 0/3] fix rescaling of scheduler tunabled
Date: Fri, 27 Nov 2009 15:45:52 +0100
Message-Id: <1259333155-14475-1-git-send-email-ehrhardt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is based on the ideas of Peter Zijlstra and me in the
discussion how to fix missing updates to the scheduler tunables in case
of cpu hot add/remove. The values are scaled on boot time but not (yet)
in the runtime #cpu changes.

The series has not yet got the testing it shouldhave, just some basic
functionality tests. But working day is ending and the patches are fine
enough for another round of discussion about the basic ideas and
implementation.

Series contains:
[PATCH 1/3] sched: fix missing sched tunable recalculation on cpu add/remove
[PATCH 2/3] sched: make tunable scaling style configurable
[PATCH 3/3] sched: update normalized values on user updates via proc

[diffstat]
 kernel/sched.c                                  |   41 ++++++++++++++----------
 kernel/sched_fair.c                             |   27 +++++++++++++++
 kernel/sysctl.c                                 |   12 ++++---
 linux-2.6-git-schedrecalc/include/linux/sched.h |   11 +++++-
 linux-2.6-git-schedrecalc/kernel/sched.c        |   15 ++++++++
 linux-2.6-git-schedrecalc/kernel/sched_debug.c  |   10 +++++
 linux-2.6-git-schedrecalc/kernel/sched_fair.c   |   12 +++++++
 linux-2.6-git-schedrecalc/kernel/sysctl.c       |   14 ++++++++
 8 files changed, 120 insertions(+), 22 deletions(-)
