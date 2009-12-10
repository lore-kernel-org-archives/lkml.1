Return-Path: <linux-kernel-owner+w=401wt.eu-S933506AbZLJHwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506AbZLJHwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933280AbZLJHwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:52:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:40030 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933274AbZLJHwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:52:37 -0500
Date: Thu, 10 Dec 2009 07:51:13 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, lizf@cn.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B20A1A9.3040104@cn.fujitsu.com>
References: <4B20A1A9.3040104@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Align long options which have no short forms
Message-ID: <tip-bc3abfb1b50964ffbbd0fc4e1ffe598b1b63a8c7@git.kernel.org>
Git-Commit-ID: bc3abfb1b50964ffbbd0fc4e1ffe598b1b63a8c7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc3abfb1b50964ffbbd0fc4e1ffe598b1b63a8c7
Gitweb:     http://git.kernel.org/tip/bc3abfb1b50964ffbbd0fc4e1ffe598b1b63a8c7
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 10 Dec 2009 15:22:17 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Dec 2009 08:30:28 +0100

perf tools: Align long options which have no short forms

Before:

$ ./perf kmem
...
    -l, --line <num>      show n lines
    --raw-ip              show raw ip instead of symbol

After:

$ ./perf kmem
...
    -l, --line <num>      show n lines
        --raw-ip          show raw ip instead of symbol

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <4B20A1A9.3040104@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/parse-options.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 6d8af48..efebd5b 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -430,6 +430,9 @@ int usage_with_options_internal(const char * const *usagestr,
 		pos = fprintf(stderr, "    ");
 		if (opts->short_name)
 			pos += fprintf(stderr, "-%c", opts->short_name);
+		else
+			pos += fprintf(stderr, "    ");
+
 		if (opts->long_name && opts->short_name)
 			pos += fprintf(stderr, ", ");
 		if (opts->long_name)
