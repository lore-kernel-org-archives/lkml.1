Return-Path: <linux-kernel-owner+w=401wt.eu-S1751551AbZFNFyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbZFNFyp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 01:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbZFNFye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 01:54:34 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:39728 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbZFNFyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 01:54:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JjZ8p3bxpQ265e+5potAfpbi/LiYFm2z80tUDzPwtnW1JKJRoE7K0tDzg7RPIozVZU
         FiySQ/IM/bS/wm7pmFSwUSyDB5izMqugJj8GM2i7iuCl4tvOy3nL+Xxa4GScW4tmJN2h
         dst1WoO+EO+iqQ9nUjqT0PhR2CJCZETabtQMk=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Linux-MIPS <linux-mips@linux-mips.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ralf Baechle <ralf@linux-mips.org>,
       Wu Zhangjin <wuzj@lemote.com>
Subject: [PATCH] kmemtrace:fix undeclared 'PAGE_SIZE' via asm/page.h
Date: Sun, 14 Jun 2009 13:54:23 +0800
Message-Id: <1244958863-28899-1-git-send-email-wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

when compiling linux-mips with kmemtrace enabled, this error will be
there:

include/linux/trace_seq.h:12: error: 'PAGE_SIZE' undeclared here (not in
				a function)

I checked the source code and found trace_seq.h used PAGE_SIZE but not
include the relative header file, so, fix it via adding the header file
<asm/page.h>

this error will not be triggered in linux-x86 for there is a
<asm/page.h> header file included in a certain header file. but which
not means <asm/page.h> is not needed in trace_seq.h

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

