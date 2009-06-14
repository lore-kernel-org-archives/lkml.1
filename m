Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbZFNGxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbZFNGxJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 02:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZFNGw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 02:52:56 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:63934 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbZFNGw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 02:52:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UkX3I9yNC0A04CYtYZH1TmbR4tWqPTHvF/DTVFSTmOMs3OubWh97KneXk9E3Jyuwjl
         M90sSTO5I61K3E5qmyTNeOZnz3RxmE4OR4l6cOIdCrSFdNu1N92BFaDKNgFnELVCThGA
         KneaBEwFFQZ3mdUVo0ASX9/fbHsk6tQPlPjBs=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Linux-MIPS <linux-mips@linux-mips.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ralf Baechle <ralf@linux-mips.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Wu Zhangjin <wuzj@lemote.com>
Subject: [PATCH] tracing: fix undeclared 'PAGE_SIZE' in include/linux/trace_seq.h
Date: Sun, 14 Jun 2009 14:52:30 +0800
Message-Id: <1244962350-28702-1-git-send-email-wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

when compiling linux-mips with kmemtrace enabled, there will be an
error:

include/linux/trace_seq.h:12: error: 'PAGE_SIZE' undeclared here (not in
				a function)

I checked the source code and found trace_seq.h used PAGE_SIZE but not
included the relative header file, so, fix it via adding the header file
<asm/page.h>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 include/linux/trace_seq.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index c68bccb..c134dd1 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -3,6 +3,8 @@
 
 #include <linux/fs.h>
 
+#include <asm/page.h>
+
 /*
  * Trace sequences are used to allow a function to call several other functions
  * to create a string of data to use (up to a max of PAGE_SIZE.
-- 
1.6.0.4

