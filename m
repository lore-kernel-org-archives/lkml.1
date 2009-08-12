Return-Path: <linux-kernel-owner+w=401wt.eu-S932537AbZHLKsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbZHLKsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932524AbZHLKsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:48:36 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53242 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525AbZHLKse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:48:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PG/I1vFSqZft8+zrZkp9H4Ankzh2prLlKb2cIkjQcUm5ZcTqHh3MTlBLvq2Lf6eMgR
         4NT/w7kxddIu01HZPl+SMRcLFJZKz1bxnMKfm/Enq3Y1aJ0z5RNrhOcIOMefneh8J8JW
         So+5OrOk1o2+I2bEFveXGwqZcIbxk+KeyMJCk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Brice Goglin <Brice.Goglin@inria.fr>
Subject: [GIT PULL v2] perf tools: Factorize common code
Date: Wed, 12 Aug 2009 12:48:29 +0200
Message-Id: <1250074112-15147-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090812100851.GA18577@elte.hu>
References: <20090812100851.GA18577@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 12:08:51PM +0200, Ingo Molnar wrote:
> yeah. I've zapped those commits from perfcounters/core.
>
>       Ingo

Ok, sorry about that.
I've rebuilt a clean tree. It should be fine now.

Thanks.

The following changes since commit 9f8666971185b86615a074bcac67c90fdf8af8bc:
  Brice Goglin (1):
        perf report: Add raw displaying of per-thread counters

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
	perfcounters/core

Frederic Weisbecker (3):
      perf tools: Factorize high level dso helpers
      perf tools: Factorize the event structure definitions in a single file
      perf tools: Factorize the map helpers

 tools/perf/Makefile           |    2 +
 tools/perf/builtin-annotate.c |  209 +-------------------------------
 tools/perf/builtin-record.c   |   20 +---
 tools/perf/builtin-report.c   |  274 +----------------------------------------
 tools/perf/builtin-stat.c     |    1 -
 tools/perf/builtin-top.c      |   24 ----
 tools/perf/builtin.h          |    1 +
 tools/perf/perf.h             |    1 +
 tools/perf/util/callchain.h   |    1 +
 tools/perf/util/debug.c       |   22 ++++
 tools/perf/util/debug.h       |    5 +
 tools/perf/util/event.h       |   84 +++++++++++++
 tools/perf/util/map.c         |   97 +++++++++++++++
 tools/perf/util/symbol.c      |   97 +++++++++++++++
 tools/perf/util/symbol.h      |   12 ++
 tools/perf/util/util.h        |    1 +
 16 files changed, 330 insertions(+), 521 deletions(-)
 create mode 100644 tools/perf/util/debug.c
 create mode 100644 tools/perf/util/debug.h
 create mode 100644 tools/perf/util/event.h
 create mode 100644 tools/perf/util/map.c
