Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZDOX2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZDOX2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 19:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbZDOX1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 19:27:36 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56069 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbZDOX1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 19:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=g9kAbK4oJGsHtYddia90hQgDA/amFio0WrWE7bVz/h/qBzxomPGwlxd1n/KCTYu7rK
         e3VqfAUIyXPBhjfHPqXvKeddVwX3f0V0cb6rDSSyBz+yFscOYi3awm5awp3jKCVvY9px
         V/o2S6FOtTO3WlJ4aoIEo70YH6qjWV8pxNED8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 2/2] tracing/lock: provide lock_acquired event support for dynamic size string
Date: Thu, 16 Apr 2009 01:27:30 +0200
Message-Id: <1239838050-8567-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1239838050-8567-1-git-send-email-fweisbec@gmail.com>
References: <1239838050-8567-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we can support the dynamic sized string, make the lock tracing
able to use it, making it safe against modules removal and consuming
the right amount of memory needed for each lock name

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/events/lockdep.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/lockdep.h b/include/trace/events/lockdep.h
index 45e326b..48356b7 100644
--- a/include/trace/events/lockdep.h
+++ b/include/trace/events/lockdep.h
@@ -38,12 +38,12 @@ TRACE_EVENT(lock_acquired,
 	TP_ARGS(lock, ip, waittime),
 
 	TP_STRUCT__entry(
-		__field(const char *, name)
 		__field(unsigned long, wait_usec)
 		__field(unsigned long, wait_nsec_rem)
+		__ending_string(name)
 	),
 	TP_fast_assign(
-		__entry->name = lock->name;
+		open_string_assign(lock_acquired, name, lock->name);
 		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
 		__entry->wait_usec = (unsigned long) waittime;
 	),
-- 
1.6.1

