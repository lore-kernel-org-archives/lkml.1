Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab0APJoc (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 04:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019Ab0APJo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 04:44:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:54230 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab0APJoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 04:44:22 -0500
Date: Sat, 16 Jan 2010 09:43:56 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <4B4E8753.2000102@cn.fujitsu.com>
References: <4B4E8753.2000102@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing/filters: Fix MATCH_MIDDLE_ONLY filter matching
Message-ID: <tip-b2af211f284eb1bef19fbb85fc8ef551bb1e7460@git.kernel.org>
Git-Commit-ID: b2af211f284eb1bef19fbb85fc8ef551bb1e7460
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Jan 2010 09:43:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2af211f284eb1bef19fbb85fc8ef551bb1e7460
Gitweb:     http://git.kernel.org/tip/b2af211f284eb1bef19fbb85fc8ef551bb1e7460
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 14 Jan 2010 10:54:11 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 14 Jan 2010 22:38:11 -0500

tracing/filters: Fix MATCH_MIDDLE_ONLY filter matching

The @str might not be NULL-terminated if it's of type
DYN_STRING or STATIC_STRING, so we should use strnstr()
instead of strstr().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4B4E8753.2000102@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 49e44dd..f364b08 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -268,7 +268,7 @@ static int regex_match_front(char *str, struct regex *r, int len)
 
 static int regex_match_middle(char *str, struct regex *r, int len)
 {
-	if (strstr(str, r->pattern))
+	if (strnstr(str, r->pattern, len))
 		return 1;
 	return 0;
 }
