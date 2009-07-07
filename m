Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbZGGFyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbZGGFyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbZGGFyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:54:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65474 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755874AbZGGFyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:54:23 -0400
Message-ID: <4A52E314.7070004@cn.fujitsu.com>
Date: Tue, 07 Jul 2009 13:54:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/8] ksym_tracer: Report error when failed to re-register
 hbp
References: <4A52E291.1020408@cn.fujitsu.com>
In-Reply-To: <4A52E291.1020408@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When access type is changed, the hw break point will be
unregistered and then be registered again with new access
type. But the registration may fail, in this case, -errno
should be returned.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_ksym.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 8cbed5a..891e3b8 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -302,13 +302,13 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 				ret = count;
 				goto unlock_ret_path;
 			}
-		}
+		} else
+			ret = count;
 		ksym_filter_entry_count--;
 		hlist_del_rcu(&(entry->ksym_hlist));
 		synchronize_rcu();
 		kfree(entry->ksym_hbp);
 		kfree(entry);
-		ret = count;
 		goto err_ret;
 	} else {
 		/* Check for malformed request: (4) */
-- 
1.5.4.rc3

