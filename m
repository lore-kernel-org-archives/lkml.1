Return-Path: <linux-kernel-owner+w=401wt.eu-S1751910AbZEUF6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbZEUF6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 01:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbZEUF6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 01:58:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64929 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbZEUF6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 01:58:07 -0400
Message-ID: <4A14EDB6.2050507@cn.fujitsu.com>
Date: Thu, 21 May 2009 13:59:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/events: change the type of __str_loc_item to unsigned
 short
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When defining a dynamic size string, we add __str_loc_##item to the
trace entry, and it stores the location of the actual string in
entry->_str_data[]

'unsigned short' should be sufficient to store this information, thus
we save 2 bytes per dyn-size string in the ring buffer.

[ Impact: reduce memory occupied by dyn-size strings in ring buffer ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/ftrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index edb02bc..b5ff2e8 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -25,7 +25,7 @@
 #define __field(type, item)		type	item;
 
 #undef __string
-#define __string(item, src)		int	__str_loc_##item;
+#define __string(item, src)		unsigned short	__str_loc_##item;
 
 #undef TP_STRUCT__entry
 #define TP_STRUCT__entry(args...) args
-- 1.5.4.rc3 
