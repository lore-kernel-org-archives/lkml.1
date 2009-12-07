Return-Path: <linux-kernel-owner+w=401wt.eu-S934532AbZLGEIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934532AbZLGEIv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 23:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933296AbZLGEIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 23:08:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59532 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933111AbZLGEIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 23:08:49 -0500
Message-ID: <4B1C7F73.80707@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 12:07:15 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] perf_event: fix __dsos__write_buildid_table()
References: <4B1C7EE1.8030906@cn.fujitsu.com> <4B1C7F45.5080105@cn.fujitsu.com>
In-Reply-To: <4B1C7F45.5080105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remain buff size is 'len - pos->long_name_len - 1', not
'len - pos->long_name_len + 1'

This bug is imported by:
Commit-ID:  7691b1ec2e4a8d4bd88dcf88b29792399ebe1c91
Gitweb:     http://git.kernel.org/tip/7691b1ec2e4a8d4bd88dcf88b29792399ebe1c91
Author:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
AuthorDate: Sun, 6 Dec 2009 20:10:49 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 6 Dec 2009 18:15:02 +0100

perf tools: Misc small fixes

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
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
-- 
1.6.1.2


