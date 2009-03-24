Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZCXHOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZCXHOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 03:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbZCXHOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 03:14:20 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:41951 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbZCXHOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 03:14:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=oxKhqIDCTR9XQthWyXjc+rHZVHWtHLTk9AQEcS1hFegqV2NO0ZwxPZ1fO5wjl7/gaJ
         G0GLmH55TYOQOC6FC5y8pbddTAfOWc7UmG6ahmWThSguOGewHyyKUldpHbw/tdHGq2tM
         cAWumhDtVjg2RrNN+hPBfdtBMy3zgq+9e/0rY=
Subject: [PATCH] tracing/filters: free pred when clearing filters
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 02:14:11 -0500
Message-Id: <1237878851.8339.58.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free the current pred when clearing the filters via the filter files.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/trace_events.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index fdab30d..a938138 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -516,6 +516,7 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	if (pred->clear) {
 		filter_free_preds(call);
+		filter_free_pred(pred);
 		return cnt;
 	}
 
@@ -581,6 +582,7 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	if (pred->clear) {
 		filter_free_subsystem_preds(system);
+		filter_free_pred(pred);
 		return cnt;
 	}
 
-- 
1.5.6.3



