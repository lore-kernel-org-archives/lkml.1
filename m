Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZJAJ7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZJAJ7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbZJAJ7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:59:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:49660 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086AbZJAJ7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:59:21 -0400
Date: Thu, 1 Oct 2009 09:58:24 GMT
From: tip-bot for Mulyadi Santosa <mulyadi.santosa@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       sam@ravnborg.org, efault@gmx.de, mulyadi.santosa@gmail.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, sam@ravnborg.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mulyadi.santosa@gmail.com, mingo@elte.hu
In-Reply-To: <f284c33d0909251201w422e9687x8cd3a784e85adf7d@mail.gmail.com>
References: <f284c33d0909251201w422e9687x8cd3a784e85adf7d@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Run generate-cmdlist.sh properly
Message-ID: <tip-1ad0560e8cdb6d5b381220dc2da187691b5ce124@git.kernel.org>
Git-Commit-ID: 1ad0560e8cdb6d5b381220dc2da187691b5ce124
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 09:58:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ad0560e8cdb6d5b381220dc2da187691b5ce124
Gitweb:     http://git.kernel.org/tip/1ad0560e8cdb6d5b381220dc2da187691b5ce124
Author:     Mulyadi Santosa <mulyadi.santosa@gmail.com>
AuthorDate: Sat, 26 Sep 2009 02:01:41 +0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Oct 2009 10:12:03 +0200

perf tools: Run generate-cmdlist.sh properly

Right now generate-cmdlist.sh is not executable, so we
should call it as an argument ".".

This fixes cases where due to different umask defaults
the generate-cmdlist.sh script is not executable in
a kernel tree checkout.

Signed-off-by: Mulyadi Santosa <mulyadi.santosa@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <f284c33d0909251201w422e9687x8cd3a784e85adf7d@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b5f1953..5881943 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -728,7 +728,7 @@ $(BUILT_INS): perf$X
 common-cmds.h: util/generate-cmdlist.sh command-list.txt
 
 common-cmds.h: $(wildcard Documentation/perf-*.txt)
-	$(QUIET_GEN)util/generate-cmdlist.sh > $@+ && mv $@+ $@
+	$(QUIET_GEN). util/generate-cmdlist.sh > $@+ && mv $@+ $@
 
 $(patsubst %.sh,%,$(SCRIPT_SH)) : % : %.sh
 	$(QUIET_GEN)$(RM) $@ $@+ && \
