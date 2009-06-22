Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZFVTRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZFVTRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZFVTRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:17:25 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:51530 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZFVTRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:17:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=WFm2q+wuLFdF0Td5NaqvroDppxA1Kazb0A8i+WjKXaGc/RDUOgPgnqEEMaVRKW05ls
         uTNCeprMIQlL/iHzRKjyO7apQiGPJlx5IhUXmlPZjb1NntMgTBUjETg+4ODUgs8jArtR
         rIk0jO1t65q/yJAeXNejMzukcFOO5Cwwjj7Ss=
Message-ID: <4A3FF508.3000304@gmail.com>
Date: Mon, 22 Jun 2009 23:18:00 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ftrace: remove redundant test on nsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unsigned `cnt' cannot be less than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Or should it be `if (!cnt || cnt > MAX)' and what should MAX be then?

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index aa08be6..b83f030 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -204,7 +204,7 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
 	char *buf;
 	char ch;
 
-	if (!cnt || cnt < 0)
+	if (!cnt)
 		return 0;
 
 	ret = tracing_update_buffers();
