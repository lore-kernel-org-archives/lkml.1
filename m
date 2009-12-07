Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbZLGFb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbZLGFb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 00:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbZLGFby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 00:31:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:49296 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbZLGFbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 00:31:53 -0500
Date: Mon, 7 Dec 2009 05:31:18 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, peterz@infradead.org,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       hirofumi@mail.parknet.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, peterz@infradead.org,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       hirofumi@mail.parknet.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B1C7F73.80707@cn.fujitsu.com>
References: <4B1C7F73.80707@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_event: Fix __dsos__write_buildid_table()
Message-ID: <tip-d9541ed3241bb6c2b805d3ea0e87563cf2a0c5c3@git.kernel.org>
Git-Commit-ID: d9541ed3241bb6c2b805d3ea0e87563cf2a0c5c3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9541ed3241bb6c2b805d3ea0e87563cf2a0c5c3
Gitweb:     http://git.kernel.org/tip/d9541ed3241bb6c2b805d3ea0e87563cf2a0c5c3
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Mon, 7 Dec 2009 12:07:15 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Dec 2009 06:26:24 +0100

perf_event: Fix __dsos__write_buildid_table()

The remain buff size is 'len - pos->long_name_len - 1', not
'len - pos->long_name_len + 1'

This bug was introduced by commit 7691b1e ("perf tools: Misc small
fixes").

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4B1C7F73.80707@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/header.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 08b6759..59a9c0b 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -209,7 +209,7 @@ static int __dsos__write_buildid_table(struct list_head *head, int fd)
 		err = do_write(fd, pos->long_name, pos->long_name_len + 1);
 		if (err < 0)
 			return err;
-		err = do_write(fd, zero_buf, len - pos->long_name_len + 1);
+		err = do_write(fd, zero_buf, len - pos->long_name_len - 1);
 		if (err < 0)
 			return err;
 	}
