Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbZIOGp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbZIOGp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 02:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbZIOGpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 02:45:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58023 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756838AbZIOGpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 02:45:22 -0400
Message-ID: <4AAF37D4.5010706@cn.fujitsu.com>
Date: Tue, 15 Sep 2009 14:44:36 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf_counter: fix buffer overflow in perf_copy_attr()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we pass a big size data over perf_counter_open syscall, the kernel
will copy this data to a small buffer, It will cause kernel crash.

This bug make kernel unsafe and no-root user can trigger it.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/perf_counter.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 667ab25..75c46c0 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -4216,6 +4216,7 @@ static int perf_copy_attr(struct perf_counter_attr __user *uattr,
 			if (val)
 				goto err_size;
 		}
+		size = sizeof(*attr);
 	}
 
 	ret = copy_from_user(attr, uattr, size);
-- 
1.6.1.2


