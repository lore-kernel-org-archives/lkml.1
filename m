Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbZEKGci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbZEKGci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 02:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbZEKGc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 02:32:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57376 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZEKGc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 02:32:27 -0400
Message-ID: <4A07C6B3.9080802@cn.fujitsu.com>
Date: Mon, 11 May 2009 14:33:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] blktrace: pdu_buf of pc events should be unsigned
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this:
  8,0    1   305.417782332  2037  I   R 32 (ffffff9e 10 00 ...) [bash]

It should be:
  8,0    1   305.417782332  2037  I   R 32 (9e 10 00 ...) [bash]

[ Impact: fix output of pc events ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c223cd1..9c5a951 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1071,7 +1071,7 @@ static int blk_log_action(struct trace_iterator *iter, const char *act)
 
 static int blk_log_dump_pdu(struct trace_seq *s, const struct trace_entry *ent)
 {
-	const char *pdu_buf;
+	const unsigned char *pdu_buf;
 	int pdu_len;
 	int i, end, ret;
 
-- 
1.5.4.rc3

