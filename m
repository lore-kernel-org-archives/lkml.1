Return-Path: <linux-kernel-owner+w=401wt.eu-S1764734AbZDIJIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764734AbZDIJIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764594AbZDIJHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:07:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:44569 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764519AbZDIJHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:07:40 -0400
Date: Thu, 9 Apr 2009 09:07:03 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090409085524.601794134@chello.nl>
References: <20090409085524.601794134@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: log full path names
Message-ID: <tip-0a24487bebbee88609004bc5a5ae1b375b292897@git.kernel.org>
Git-Commit-ID: 0a24487bebbee88609004bc5a5ae1b375b292897
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 09:07:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a24487bebbee88609004bc5a5ae1b375b292897
Gitweb:     http://git.kernel.org/tip/0a24487bebbee88609004bc5a5ae1b375b292897
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 9 Apr 2009 10:53:46 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Apr 2009 11:00:54 +0200

perf_counter: log full path names

Impact: fix perf-report output for /home mounted binaries, etc.

dentry_path() only provide path-names up to the mount root, which is
unsuited for out purpose, use d_path() instead.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090409085524.601794134@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index a2fa5bc..0d646ac 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2111,7 +2111,7 @@ static void perf_counter_mmap_event(struct perf_mmap_event *mmap_event)
 			name = strncpy(tmp, "//enomem", sizeof(tmp));
 			goto got_name;
 		}
-		name = dentry_path(file->f_dentry, buf, PATH_MAX);
+		name = d_path(&file->f_path, buf, PATH_MAX);
 		if (IS_ERR(name)) {
 			name = strncpy(tmp, "//toolong", sizeof(tmp));
 			goto got_name;
