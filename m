Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211AbYKFHf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbYKFHf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYKFHfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:35:48 -0500
Received: from mail.ch.keymile.com ([193.17.201.103]:59046 "HELO
	mail.ch.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752865AbYKFHfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:35:46 -0500
X-Greylist: delayed 774 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Nov 2008 02:35:45 EST
Subject: Scheduler RR, first time slice wrong?
From: Andreas Huber <andreas.huber@keymile.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Nov 2008 08:22:47 +0100
Message-Id: <1225956167.4472.27.camel@chber1-10446x.ch.keymile.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
X-ESAFE-STATUS: Mail allowed
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when starting a real-time process with the round-robin scheduler, the
first time slice is set to HZ (1 second).
When starting two such processes at the same time of the same static
priority, the second one started is first executed after 1 second.
(supposing the first process is heavy on cpu load).
After both have exhausted this first time slice, it is set to
DEF_TIMESLICE (which is 100ms).

Is this behavior as it is supposed to be?

Please add me in CC.

Regards,
Andreas


Relevant parts in the code:
include/linux/init_task.h
#define INIT_TASK(tsk) \
	.rt	= { \
		.time_slice = HZ,

kernel/sched.c
#define DEF_TIMESLICE   (100 * HZ / 1000)

kernel/sched_rt.c
static void task_tick_rt(struct rq *rq, struct task_struct *p, int
queued)
  if (--p->rt.time_slice)
    return;

  p->rt.time_slice = DEF_TIMESLICE;

