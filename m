Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260Ab0AJBi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab0AJBi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 20:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625Ab0AJBiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 20:38:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:10729 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab0AJBiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 20:38:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jMSMRBaDVWMQ8C3VnGezfG3sBX72dDkr/4i1Rvz8aYn6BbJCjm+qopij3djub4oiBn
         beEFxyZQ5u3DALpbunnDj7u0z/bi7uayDbdxkRFkvErvizdoerhNuWw+ehz603gH3JJP
         3OvYBE+GIkoLtSXSt/oDTdIhmQHYI5hN3BzkM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 0/6] perf: Various event scheduling improvements
Date: Sun, 10 Jan 2010 02:38:14 +0100
Message-Id: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches bring (I hope) a bit more scalability and fairness
to the perf events scheduling.

But this is only an introduction as there is still some work to
do, like ensuring all pinned events have been scheduled before
flexible ones (for now we schedule in order cpu pinned, cpu flexible,
task pinned, task flexible), among other improvements.


Frederic Weisbecker (6):
  perf/core: Split context's event group list into pinned and non-pinned lists
  list: Introduce list_rotate_left()
  perf: Round robin groups of events using list_rotate_left()
  perf: Export software-only event group characteristic as a flag
  perf: Don't rotate pinned groups
  perf: Increase round-robin fairness of flexible events

 include/linux/list.h       |   14 +++
 include/linux/perf_event.h |    8 +-
 kernel/perf_event.c        |  262 +++++++++++++++++++++++++++-----------------
 3 files changed, 184 insertions(+), 100 deletions(-)

