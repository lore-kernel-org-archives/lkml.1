Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbZKKVOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbZKKVOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758877AbZKKVOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:14:31 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:5384 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758680AbZKKVOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:14:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=gJSOOun4T35hZfF3pSSE9FK8/g9Ly5QZgxeE6oryeWe99Z9/alBGqtpefD0GY+fprL
         ybiuaqKGR8ENpT2gmp3HEjwmM+dTZb0td4bC10ME+P1gHXBgNd4JyieAXEPC2TP2XWZH
         UfzQFl36UnX1UTx5iVKHpGBEyhiw9U3ycQBYU=
Message-ID: <4AFB2C0B.50605@gmail.com>
Date: Wed, 11 Nov 2009 22:26:35 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ingo <mingo@elte.hu>,
       rostedt@goodmis.org
Subject: [PATCH] ftrace: return error instead of 12 bytes read
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A negative error value is required: now we cannot
distinguish ENOMEM from a valid read of 12 bytes.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b20d3ec..03c7fd5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3730,7 +3730,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
-		return ENOMEM;
+		return -ENOMEM;
 
 	trace_seq_init(s);
 
