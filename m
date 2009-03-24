Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbZCXIGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbZCXIGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756842AbZCXIF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:05:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62334 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756740AbZCXIFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:05:25 -0400
Message-ID: <49C8945F.5020802@cn.fujitsu.com>
Date: Tue, 24 Mar 2009 16:05:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] blktrace: fix t_error()
References: <49C893FC.9080905@cn.fujitsu.com>
In-Reply-To: <49C893FC.9080905@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

t_error() should return t->error but not t->sector.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 0e91caa..f33c176 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -968,7 +968,7 @@ static inline unsigned long long t_sector(const struct trace_entry *ent)
 
 static inline __u16 t_error(const struct trace_entry *ent)
 {
-	return te_blk_io_trace(ent)->sector;
+	return te_blk_io_trace(ent)->error;
 }
 
 static __u64 get_pdu_int(const struct trace_entry *ent)
-- 
1.5.4.rc3

