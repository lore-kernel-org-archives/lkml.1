Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZEZCFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZEZCFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 22:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbZEZCE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 22:04:57 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:27600 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbZEZCE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 22:04:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YhJRQR5Sq5F/CgjXgNv2vkVTaUWOB1YOTWSqW8CLvApBipMtFJmKYuhcJg1X5cmsrZ
         1uawW0Y4AepPg+oIIfepM5Bhj+A/Cm+3D67SMowjxdDE2u4t9kZrQncTuHO7mI0d7ost
         VZI3qoT480j28t7ihaFXG60h7XSJ42oVDHaLA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/5] tracing/events: change the type of __str_loc_item to unsigned short
Date: Tue, 26 May 2009 04:04:47 +0200
Message-Id: <1243303490-8019-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243303490-8019-1-git-send-email-fweisbec@gmail.com>
References: <1243303490-8019-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

When defining a dynamic size string, we add __str_loc_##item to the
trace entry, and it stores the location of the actual string in
entry->_str_data[]

'unsigned short' should be sufficient to store this information, thus
we save 2 bytes per dyn-size string in the ring buffer.

[ Impact: reduce memory occupied by dyn-size strings in ring buffer ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A14EDB6.2050507@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
-- 
1.6.2.3

