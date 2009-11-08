Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbZKHUNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbZKHUNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbZKHUNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:13:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:48384 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbZKHUNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:13:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RBhypzj753zmFYHsgg6gCFqmEIV1kpiDAN+7OvgK4kpPITO/nExVGvyUmq2MbvcCRj
         9emzzTvgNBVrVu39V705+XMWg7yCMTwhxyMW7qMrNfZFA2oiVUSXSDxS/yCS25doQ+NJ
         S+mmzP+FmWnP8DTJspkHIgL8grwCaooaNKhEA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 0/4] perf/core: Small event scheduling changes
Date: Sun,  8 Nov 2009 21:13:22 +0100
Message-Id: <1257711206-12243-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is an rfc patchset, only compile tested just to ensure I'm taking
a good direction before going ahead.

This is intended to rework a bit the perf event scheduling to
guarantee a real priority of the pinned events over the volatile
ones. This patchset handles such priority on task tick time
only. But if the idea is agreed, I could expand that to every
task event sched-in calls to guarantee the priority in every
event rescheduling time.

Thanks.

Frederic Weisbecker (4):
  perf/core: split context's event group list into pinned and
    non-pinned lists
  perf/core: Optimize a bit rotate_ctx()
  perf/core: Split up pinned and non pinned processing
  perf/core: Schedule every pinned events before the the non-pinned

 include/linux/perf_event.h |    3 +-
 kernel/perf_event.c        |  283 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 212 insertions(+), 74 deletions(-)

