Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924Ab0A3Lno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0A3Lno (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 06:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583Ab0A3Lnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 06:43:42 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52218 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab0A3Lni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 06:43:38 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH 00/12 v2] perf lock: New subcommand "perf lock", for analyzing lock statistics
Date: Sat, 30 Jan 2010 20:43:22 +0900
Message-Id: <1264851813-8413-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding new subcommand "perf lock" to perf.

I made this patch series on
latest perf/core of tip (ef12a141306c90336a3a10d40213ecd98624d274),
so please apply this series to perf/core.

This patch is version 2.
I removed lack of util/include/linux/hash.h
and compile error of builtin-lock.c on 32bit env.

Sorry for my slow work, Frederic and Ingo.
I have a lot of rest ToDos,
but finally perf lock can provide minimal functions for analyzing lock statistics.

This series requires one more revirting patch.
But it is very temporary solution,
so I cannot make this series include it.
I'll send it as reply to this cover letter later only for testing,
if you are interested in testing this series,
you need to apply it.

Hitoshi Mitake (11):
  perf tools: Add __data_loc support
  perf: Add util/include/linuxhash.h to include hash.h of kernel
  lockdep: Add information of file and line where lock inited to struct
    lockdep_map
  lockdep: Add file and line to initialize sequence of spinlock
  lockdep: Add file and line to initialize sequence of rwlock
  lockdep:  Add file and line to initialize sequence of rwsem
  lockdep:  Add file and line to initialize sequence of rwsem (x86)
  lockdep: Add file and line to initialize sequence of mutex
  lockdep: Fix the way to initialize class_mutex for information of
    file and line
  perf lock: Enhance information of lock trace events
  perf lock: New subcommand "perf lock", for analyzing lock statistics

 arch/x86/include/asm/rwsem.h         |    9 +-
 drivers/base/class.c                 |    3 +-
 include/linux/lockdep.h              |   20 +-
 include/linux/mutex-debug.h          |    2 +-
 include/linux/mutex.h                |   12 +-
 include/linux/rwlock.h               |    6 +-
 include/linux/rwlock_types.h         |    6 +-
 include/linux/rwsem-spinlock.h       |   11 +-
 include/linux/spinlock.h             |    6 +-
 include/linux/spinlock_types.h       |    6 +-
 include/trace/events/lock.h          |   49 ++-
 kernel/lockdep.c                     |   10 +-
 kernel/mutex-debug.c                 |    5 +-
 kernel/mutex-debug.h                 |    3 +-
 kernel/mutex.c                       |    5 +-
 kernel/mutex.h                       |    2 +-
 lib/rwsem-spinlock.c                 |    5 +-
 lib/rwsem.c                          |    5 +-
 lib/spinlock_debug.c                 |   12 +-
 tools/perf/Makefile                  |    2 +
 tools/perf/builtin-lock.c            |  724 ++++++++++++++++++++++++++++++++++
 tools/perf/builtin.h                 |    1 +
 tools/perf/perf.c                    |    1 +
 tools/perf/util/include/linux/hash.h |    5 +
 tools/perf/util/trace-event-parse.c  |    7 +
 25 files changed, 870 insertions(+), 47 deletions(-)
 create mode 100644 tools/perf/builtin-lock.c
 create mode 100644 tools/perf/util/include/linux/hash.h

