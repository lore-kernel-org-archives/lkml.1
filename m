Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbZFBU5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbZFBU5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbZFBU5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:57:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:58762 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbZFBU5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:57:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=xDNPUETJxZOsPlHaEfYVfxS5x15AU/wvp94fMAzeGgnPgs5AZ59lm37aZppUTs6WY6
         eX4JIiK7TSfc6KnQoXVGgVTRt1AcYXWL+TFEa6KzURDOtMqBLZ9jiQzsm5w2jFk0QC6l
         uSGCPHtogYXtflMfCPCOvEh21Cmu9foAEDJqA=
Message-ID: <4A25AE50.4090108@gmail.com>
Date: Wed, 03 Jun 2009 00:57:20 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] tracing/mm: val should be signed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If not signed the `val < 0' test below doesn't make sense.
Also strict_strtol requires a long pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I think this is what was intended? please review.

diff --git a/kernel/trace/trace_mm.c b/kernel/trace/trace_mm.c
index 4bc7fc0..9af2351 100644
--- a/kernel/trace/trace_mm.c
+++ b/kernel/trace/trace_mm.c
@@ -54,7 +54,8 @@ static ssize_t
 trace_mm_dump_range_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		       loff_t *ppos)
 {
-	unsigned long val, start, end;
+	unsigned long start, end;
+	long val;
 	char buf[64];
 	int ret;
 
