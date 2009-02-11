Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbZBKCj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbZBKCj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 21:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbZBKCjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 21:39:48 -0500
Received: from mail-bw0-f167.google.com ([209.85.218.167]:46894 "EHLO
	mail-bw0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654AbZBKCjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 21:39:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:date:subject;
        b=ASFdqbuJbIEGRzMcz7uQrADPhtjtZ2Fp0nvONr6Y3MCSw1hYoR/cDflXQ9mk9KzN7X
         ZFjYVYFaHyHeQ4LTCq7NxAdYwfQp8jlHVTAF9spqspti7GD1jPDnPgn9vohxxqLV4Vx4
         2Xa/N9d37ZlxyiL4evQmJ9Hf2ytVARScOei2U=
Message-ID: <49923a71.0637560a.3732.1d45@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Wed, 11 Feb 2009 02:51:30 +0100
Subject: [PATCH 2/2] tracing/core: remove unused parameter in tracing_fill_pipe_page()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

The struct page *pages parameter is unused.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9c3b684..dd66168 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2567,8 +2567,7 @@ static struct pipe_buf_operations tracing_pipe_buf_ops = {
 };
 
 static size_t
-tracing_fill_pipe_page(struct page *pages, size_t rem,
-			struct trace_iterator *iter)
+tracing_fill_pipe_page(size_t rem, struct trace_iterator *iter)
 {
 	size_t count;
 	int ret;
@@ -2645,7 +2644,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		if (!pages[i])
 			break;
 
-		rem = tracing_fill_pipe_page(pages[i], rem, iter);
+		rem = tracing_fill_pipe_page(rem, iter);
 
 		/* Copy the data into the page, so we can start over. */
 		ret = trace_seq_to_buffer(&iter->seq,
-- 
1.6.1


