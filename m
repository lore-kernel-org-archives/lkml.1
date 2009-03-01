Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbZCAUzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbZCAUzx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 15:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbZCAUzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 15:55:44 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:35625 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbZCAUzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 15:55:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=GwdMLPlCWdFF9fXJuHYhOCCiiP3+HEEoIrqKNXQ39WFBLmfDyDp7jm9vBUWYCqianu
         mSR3ZFD20oHq38ZuWQ2f/Ing/zKRTC0eHbpSI37a/n8uiek2noJ8HLFHmgx0L0lLsLOL
         9907HR8y4xzo5MAhXRWhSbqQfuQ0vnnpW5mFU=
Message-ID: <49AAF64E.9070205@gmail.com>
Date: Sun, 01 Mar 2009 21:55:42 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ftrace: '< 0' test on unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

or should this be fixed, with

        if (!cnt || cnt > DEFINE)

if so, what should DEFINE be?

This patch wasn't tested in any way.
------------------------------>8-------------8<---------------------------------
cnt is unsigned, so the '< 0' test won't work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index fdf913d..6dab415 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1129,7 +1129,7 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	size_t read = 0;
 	ssize_t ret;
 
-	if (!cnt || cnt < 0)
+	if (!cnt || (ssize_t)cnt < 0)
 		return 0;
 
 	mutex_lock(&ftrace_regex_lock);

