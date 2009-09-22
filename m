Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbZIVFxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbZIVFxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbZIVFxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:53:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52923 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbZIVFxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:53:05 -0400
Message-ID: <4AB865FA.5080801@cn.fujitsu.com>
Date: Tue, 22 Sep 2009 13:51:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] tracing: fix off-by-one in trace_get_user()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leave the last slot for the tailing '\0'.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

I spent some time reviewing the trace parser patchset,
and found a few small bugs in it, and here are the fixes.

---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a35925d..ae17453 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -415,7 +415,7 @@ int trace_get_user(struct trace_parser *parser, const char __user *ubuf,
 
 	/* read the non-space input */
 	while (cnt && !isspace(ch)) {
-		if (parser->idx < parser->size)
+		if (parser->idx < parser->size - 1)
 			parser->buffer[parser->idx++] = ch;
 		else {
 			ret = -EINVAL;
-- 
1.6.3

