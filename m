Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560Ab0AQHBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0AQHBG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 02:01:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290Ab0AQHBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 02:01:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:46617 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab0AQHBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 02:01:03 -0500
Date: Sun, 17 Jan 2010 06:58:54 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1263648075-3858-1-git-send-regression-fweisbec@gmail.com>
References: <1263648075-3858-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix implicit declaration of getline in util.c
Message-ID: <tip-69e3f52d1b1a3ed4390bb8a09bb1324265af7fbf@git.kernel.org>
Git-Commit-ID: 69e3f52d1b1a3ed4390bb8a09bb1324265af7fbf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 17 Jan 2010 06:58:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69e3f52d1b1a3ed4390bb8a09bb1324265af7fbf
Gitweb:     http://git.kernel.org/tip/69e3f52d1b1a3ed4390bb8a09bb1324265af7fbf
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sat, 16 Jan 2010 14:21:15 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 17 Jan 2010 07:53:09 +0100

perf: Fix implicit declaration of getline in util.c

getline() is considered as undeclared in util/util.c because
it includes string.h, that in turn includes stdio.h, without
having defined _GNU_SOURCE.

But util.c also includes util.h that handles the _GNU_SOURCE and
all the needed inclusions already. Let's include only util.h
and sys/mman.h which is the only one header not handled by
util.h

This fixes the following build error:

 util/util.c: In function 'slow_copyfile':
 util/util.c:49: erreur: implicit declaration of function
 'getline' util/util.c:49: erreur: nested extern declaration of 'getline'

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1263648075-3858-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/util.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index f068584..f9b890f 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,10 +1,5 @@
-#include <sys/mman.h>
-#include <sys/stat.h>
-#include <sys/types.h>
-#include <fcntl.h>
-#include <string.h>
-#include <unistd.h>
 #include "util.h"
+#include <sys/mman.h>
 
 int mkdir_p(char *path, mode_t mode)
 {
