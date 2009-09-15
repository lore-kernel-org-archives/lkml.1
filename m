Return-Path: <linux-kernel-owner+w=401wt.eu-S1751926AbZIOJWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbZIOJWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbZIOJWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:22:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:46580 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbZIOJWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:22:08 -0400
Date: Tue, 15 Sep 2009 09:21:38 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, xiaoguangrong@cn.fujitsu.com,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       xiaoguangrong@cn.fujitsu.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4AAF37D4.5010706@cn.fujitsu.com>
References: <4AAF37D4.5010706@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/urgent] perf_counter: Fix buffer overflow in perf_copy_attr()
Message-ID: <tip-b3e62e35058fc744ac794611f4e79bcd1c5a4b83@git.kernel.org>
Git-Commit-ID: b3e62e35058fc744ac794611f4e79bcd1c5a4b83
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:21:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3e62e35058fc744ac794611f4e79bcd1c5a4b83
Gitweb:     http://git.kernel.org/tip/b3e62e35058fc744ac794611f4e79bcd1c5a4b83
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Tue, 15 Sep 2009 14:44:36 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 09:53:31 +0200

perf_counter: Fix buffer overflow in perf_copy_attr()

If we pass a big size data over perf_counter_open() syscall,
the kernel will copy this data to a small buffer, it will
cause kernel crash.

This bug makes the kernel unsafe and non-root local user can
trigger it.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul Mackerras <paulus@samba.org>
Cc: <stable@kernel.org>
LKML-Reference: <4AAF37D4.5010706@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d7cbc57..a67a1dc 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -4171,6 +4171,7 @@ static int perf_copy_attr(struct perf_counter_attr __user *uattr,
 			if (val)
 				goto err_size;
 		}
+		size = sizeof(*attr);
 	}
 
 	ret = copy_from_user(attr, uattr, size);
