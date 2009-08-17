Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZHQFk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZHQFk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 01:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbZHQFk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 01:40:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57752 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbZHQFk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 01:40:58 -0400
Message-ID: <4A88ED15.20800@cn.fujitsu.com>
Date: Mon, 17 Aug 2009 13:39:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] lock_dep: Fix missing entry in /proc/lock_stat
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One entry is missing in the output of /proc/lock_stat.

The cause is, when ls_start() is called the 2nd time, we should start
from stats[@pos-1] but not stats[@pos], because pos == 0 is the header.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/lockdep_proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 98cc796..0c39f18 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -634,7 +634,7 @@ static void *ls_start(struct seq_file *m, loff_t *pos)
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
 
-	data->iter = data->stats + *pos;
+	data->iter = data->stats + (*pos - 1);
 	if (data->iter >= data->iter_end)
 		data->iter = NULL;
 
-- 
1.6.3

