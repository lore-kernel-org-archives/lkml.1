Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbZJAKAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbZJAKAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 06:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbZJAKAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 06:00:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:55894 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080AbZJAKAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 06:00:39 -0400
Date: Thu, 1 Oct 2009 09:59:41 GMT
From: tip-bot for Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, penberg@cs.helsinki.fi,
       eduard.munteanu@linux360.ro, lethal@linux-sh.org, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, lizf@cn.fujitsu.com,
       eduard.munteanu@linux360.ro, lethal@linux-sh.org, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090928075540.GD6668@linux-sh.org>
References: <20090928075540.GD6668@linux-sh.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] kmemtrace: Fix up tracer registration
Message-ID: <tip-f9ac5a69edee0ee7e06a05727226e3f275306c8d@git.kernel.org>
Git-Commit-ID: f9ac5a69edee0ee7e06a05727226e3f275306c8d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 09:59:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9ac5a69edee0ee7e06a05727226e3f275306c8d
Gitweb:     http://git.kernel.org/tip/f9ac5a69edee0ee7e06a05727226e3f275306c8d
Author:     Paul Mundt <lethal@linux-sh.org>
AuthorDate: Mon, 28 Sep 2009 16:55:40 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Oct 2009 11:53:44 +0200

kmemtrace: Fix up tracer registration

Commit ddc1637af217dbd8bc51f30e6d24e84476a869a6 ("kmemtrace: Print
binary output only if 'bin' option is set") ended up inverting the
error detection logic. register_tracer() returns 0 on success,
which this change caused to treat as an error, resulting in:

[    0.132000] Warning: could not register the kmem tracer

as well as bailing out of the initcall with an error value. This
restores the old logic.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <20090928075540.GD6668@linux-sh.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/kmemtrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 81b1645..a91da69 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -501,7 +501,7 @@ static int __init init_kmem_tracer(void)
 		return 1;
 	}
 
-	if (!register_tracer(&kmem_tracer)) {
+	if (register_tracer(&kmem_tracer) != 0) {
 		pr_warning("Warning: could not register the kmem tracer\n");
 		return 1;
 	}
