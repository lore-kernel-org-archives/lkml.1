Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbZCXMNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbZCXMNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbZCXMN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:13:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:44729 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481AbZCXMNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:13:25 -0400
Date: Tue, 24 Mar 2009 12:12:46 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       jens.axboe@oracle.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49C8945F.5020802@cn.fujitsu.com>
References: <49C8945F.5020802@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: fix t_error()
Message-ID: <tip-e0dc81bec0927fa0c8aabc521793161909eef7a5@git.kernel.org>
Git-Commit-ID: e0dc81bec0927fa0c8aabc521793161909eef7a5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 12:12:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e0dc81bec0927fa0c8aabc521793161909eef7a5
Gitweb:     http://git.kernel.org/tip/e0dc81bec0927fa0c8aabc521793161909eef7a5
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 24 Mar 2009 16:05:51 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 13:09:00 +0100

blktrace: fix t_error()

Impact: fix error flag output

t_error() should return t->error but not t->sector.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <49C8945F.5020802@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 9af4143..f69f8bd 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -968,7 +968,7 @@ static inline unsigned long long t_sector(const struct trace_entry *ent)
 
 static inline __u16 t_error(const struct trace_entry *ent)
 {
-	return te_blk_io_trace(ent)->sector;
+	return te_blk_io_trace(ent)->error;
 }
 
 static __u64 get_pdu_int(const struct trace_entry *ent)
