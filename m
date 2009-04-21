Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZDUJLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZDUJLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZDUJLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:11:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54804 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbZDUJLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:11:33 -0400
Message-ID: <49ED8DFD.9070909@cn.fujitsu.com>
Date: Tue, 21 Apr 2009 17:12:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] tracing/filters: disallow newline as delimeter
References: <49ED8DD2.2070700@cn.fujitsu.com>
In-Reply-To: <49ED8DD2.2070700@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess because user input is often ended with '\n' (like "echo xxx"),
thus '\n' is used as a delimeter besides ' ', but we can just strip
tailing spaces.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 6541828..0cc6229 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -423,7 +423,9 @@ int filter_parse(char **pbuf, struct filter_pred *pred)
 	char *tok, *val_str = NULL;
 	int tok_n = 0;
 
-	while ((tok = strsep(pbuf, " \n"))) {
+	strstrip(*pbuf);
+
+	while ((tok = strsep(pbuf, " "))) {
 		if (tok_n == 0) {
 			if (!strcmp(tok, "0")) {
 				pred->clear = 1;
-- 
1.5.4.rc3

