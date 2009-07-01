Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbZGADf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbZGADf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 23:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbZGADfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 23:35:17 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:56142 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbZGADfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 23:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TWQsTTKbaKUtrQFehI07NAeiDhd1p6SYKen8gV5y8QEkEl8P5V4kiV7z32o1B5Iu+z
         jK0qIzPQ/xCNUujnufsJSmvNzoLDO2WpPQ/1HnKrDRPoHGEobgNz2EJRTculuzXoFCVc
         7u/fm0DDuB5T4wANIO3cCYMwEUEcmDVMkMVwk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] perfcounter: callchain symbol resolving and fixes
Date: Wed,  1 Jul 2009 05:35:12 +0200
Message-Id: <1246419315-9968-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset provides the symbol resolving for callchains.
Example:

perf report -s sym -c

5.40%  [k] __d_lookup
             3.60%
                __d_lookup
                perf_callchain
                perf_counter_overflow
                intel_pmu_handle_irq
                perf_counter_nmi_handler
                notifier_call_chain
                atomic_notifier_call_chain
                notify_die
                do_nmi
                nmi
                do_lookup
                __link_path_walk
                path_walk
                do_path_lookup
                user_path_at
                vfs_fstatat
                vfs_lstat
                sys_newlstat
                system_call_fastpath
                __lxstat
                0x406fb1

             1.26%
                __d_lookup
                perf_callchain
                perf_counter_overflow
                intel_pmu_handle_irq
                perf_counter_nmi_handler
                notifier_call_chain
                atomic_notifier_call_chain
                notify_die
                do_nmi
                nmi
                do_lookup
                __link_path_walk
                path_walk
                do_path_lookup
                user_path_at
                vfs_fstatat
                vfs_lstat
                sys_newlstat
                system_call_fastpath
                __lxstat
[...]

Sorry about the third patch, it's a kind of all-in-one monolithic thing which
gathers various fixes. I should have granulate it...

Still in my plans:

- profit we have a tree to display a better graph hierarchy
- let the user provide a limit for hit percentage, depth, number of
  backtraces, etc...
- better output
- colors

And another one:

- remove the perfcounter internal nmi call frame (ie: every nmi frame)
  so that we drop this header from each callchain:

                perf_callchain
                perf_counter_overflow
                intel_pmu_handle_irq
                perf_counter_nmi_handler
                notifier_call_chain
                atomic_notifier_call_chain
                notify_die
                do_nmi
                nmi

Frederic.

Frederic Weisbecker (3):
  perfcounter: Fix storage size allocation of callchain list
  perfcounter: Resolve symbols in callchains
  perfcounter: Various fixes for callchains

 tools/perf/builtin-report.c |  102 ++++++++++++++++++++++-----------
 tools/perf/util/callchain.c |  131 ++++++++++++++++++++++++++++++++-----------
 tools/perf/util/callchain.h |    5 +-
 3 files changed, 168 insertions(+), 70 deletions(-)

