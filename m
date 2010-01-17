Return-Path: <linux-kernel-owner+w=401wt.eu-S1752221Ab0AQMWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab0AQMWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 07:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039Ab0AQMWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 07:22:20 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55488 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab0AQMWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 07:22:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MFn3ghYRw62v9WPZ1RuNMeDAWTWdIpeA/9/16qTMhaHAn0fQxCUkKk0SZIUldWnn8u
         Qvetg8xsDyJjskqeFnHcet/Vm6C+46tGj7bKhhNLe/uHwRBK4PfTT4gNDvQmSIFt1KUA
         OT3esWOLGcQzhASdijhhw8US7TL2pqJnZdx2E=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: [GIT PULL] perf scheduling updates: flexible/pinned groups reordering, optimizations
Date: Sun, 17 Jan 2010 13:22:11 +0100
Message-Id: <1263730935-9770-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/scheduling branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/scheduling

It brings more progresses wrt scheduling ordering between pinned
and flexible events.

There is still some work to do, for example concerning context spinlocks
that could be acquired once instead of multiple times in some areas.

But this set is still much more optimized than what we had before,
especially because of the third patch.

Thanks,
	Frederic
---

Frederic Weisbecker (4):
      perf: Make __perf_event_sched_out static
      perf: Allow pinned and flexible groups to be scheduled separately
      perf: Don't schedule out/in pinned events on task tick
      perf: Better order flexible and pinned scheduling


 kernel/perf_event.c |  149 +++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 109 insertions(+), 40 deletions(-)
