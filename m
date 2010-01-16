Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab0APJnm (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 04:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660Ab0APJnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 04:43:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:54198 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab0APJni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 04:43:38 -0500
Date: Sat, 16 Jan 2010 09:43:10 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <4B4E8721.5090301@cn.fujitsu.com>
References: <4B4E8721.5090301@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing/filters: Fix MATCH_FRONT_ONLY filter matching
Message-ID: <tip-285caad415f459f336247932b4db95a571357a02@git.kernel.org>
Git-Commit-ID: 285caad415f459f336247932b4db95a571357a02
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Jan 2010 09:43:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  285caad415f459f336247932b4db95a571357a02
Gitweb:     http://git.kernel.org/tip/285caad415f459f336247932b4db95a571357a02
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 14 Jan 2010 10:53:21 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 14 Jan 2010 22:38:05 -0500

tracing/filters: Fix MATCH_FRONT_ONLY filter matching

MATCH_FRONT_ONLY actually is a full matching:

  # ./perf record -R -f -a -e lock:lock_acquire \
	--filter 'name ~rcu_*' sleep 1
  # ./perf trace
  (no output)

We should pass the length of the pattern string to strncmp().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4B4E8721.5090301@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 50504cb..11c3973 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -261,7 +261,7 @@ static int regex_match_full(char *str, struct regex *r, int len)
 
 static int regex_match_front(char *str, struct regex *r, int len)
 {
-	if (strncmp(str, r->pattern, len) == 0)
+	if (strncmp(str, r->pattern, r->len) == 0)
 		return 1;
 	return 0;
 }
