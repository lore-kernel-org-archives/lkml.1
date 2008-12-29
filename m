Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbYL2Bka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbYL2Bka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 20:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYL2Bj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 20:39:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:10146 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYL2Bjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 20:39:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=q6Be000Q9orygDqMEoII4pogP1YZYfE8BmjUAwT0kvY0uDbCMo8lmnMfaKF20KbB3H
         N+csCCmkVqELheqnckIFWTjbJzsvZpV764jcSIlZk+nxKVFA0z0eoBnhqi6z1lSHV9zx
         U2mrwSKMQ2emZctjii7+Wd3FLd0IxQIXYI6Dg=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] kmemtrace over tracepoints
Date: Mon, 29 Dec 2008 03:40:05 +0200
Message-Id: <cover.1230499486.git.eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

As suggested by Mathieu Desnoyers, here's kmemtrace w/ tracepoints instead
of markers. The RCU stuff has been giving me some headaches because of
circular dependencies, but I think I've got it right.

I'm currently working on another thing Mathieu suggested, that is
variable-length fields, so we don't waste space on non-64-bit arches.

Pekka, please merge this if it looks okay. I'll try to come up in time with
the stuff described above; however, should I not be ready in time, please
ask Linus to git-pull whatever we've got at present. Hopefully, it'll get
in this time.

Alexey Dobriyan, please see if that problem you reported when kmemtrace was
using markers is still there.

And (for everybody) please be kind and test and report whatever problems
appear if possible.


	Happy holidays,
	Eduard

Eduard - Gabriel Munteanu (3):
  RCU: Move some definitions to minimal headers.
  tracepoints: Include only minimal RCU headers in linux/tracepoint.h.
  kmemtrace: Use tracepoints instead of markers.

 include/linux/kmemtrace.h      |   76 +++------------
 include/linux/rcuclassic.h     |   40 +--------
 include/linux/rcuclassic_min.h |   77 +++++++++++++++
 include/linux/rcupdate.h       |  160 +-------------------------------
 include/linux/rcupdate_min.h   |  205 ++++++++++++++++++++++++++++++++++++++++
 include/linux/rcupreempt.h     |   32 +------
 include/linux/rcupreempt_min.h |   68 +++++++++++++
 include/linux/slab_def.h       |   11 +-
 include/linux/slub_def.h       |   16 ++--
 include/linux/tracepoint.h     |    2 +-
 lib/Kconfig.debug              |    2 +-
 mm/kmemtrace.c                 |   50 +++++-----
 mm/slab.c                      |   27 +++---
 mm/slob.c                      |   32 +++---
 mm/slub.c                      |   36 ++++----
 15 files changed, 457 insertions(+), 377 deletions(-)
 create mode 100644 include/linux/rcuclassic_min.h
 create mode 100644 include/linux/rcupdate_min.h
 create mode 100644 include/linux/rcupreempt_min.h

