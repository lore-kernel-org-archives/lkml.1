Return-Path: <linux-kernel-owner+w=401wt.eu-S933097AbZKXOj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097AbZKXOj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933060AbZKXOjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:39:25 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:53769 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038AbZKXOjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:39:24 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH 0/3] perf bench: Add new benchmark for futex subsystem
Date: Tue, 24 Nov 2009 23:39:12 +0900
Message-Id: <1259073555-7312-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091118033741.GB23808@google.com>
References: <20091118033741.GB23808@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks, sorry for my very slow response...

I found that Darren's futextest contains Michel's test program now.
So I added it to 'perf bench' as sample.
If you like this style, I'd like to add rest part of futextest.

Example of use:
| % ./perf bench futex wait -t 48 -l 100000000
| # Running futex/wait benchmark...
| # Running 48 threads
| # Total number of iteration: 100000000
|    16233.763636 Kiter/sec
|        6.100000 user sec
|        0.000000 system sec
|        6.160000 wall sec
|        0.990260 cores
| % perf bench --format=simple futex wait
| 16207.455429

This patch series contains two typedefs (and one volatile).
I know typedef and volatile is not a thing to welcome.
But I judged these are not problematic things,
could you review this?

Hitoshi Mitake (3):
  perf bench: Add wrappers for atomic operation of GCC
  perf bench: Add new files for futex performance test
  perf bench: Fix misc files to build files related to futex

 tools/perf/Makefile                  |    1 +
 tools/perf/bench/bench.h             |    3 +-
 tools/perf/bench/futex-wait.c        |  218 ++++++++++++++++++++++++++
 tools/perf/bench/futextest.h         |  280 ++++++++++++++++++++++++++++++++++
 tools/perf/builtin-bench.c           |   16 ++-
 tools/perf/util/include/asm/atomic.h |   91 +++++++++++
 6 files changed, 606 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/bench/futex-wait.c
 create mode 100644 tools/perf/bench/futextest.h
 create mode 100644 tools/perf/util/include/asm/atomic.h

