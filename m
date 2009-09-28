Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbZI1H4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbZI1H4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 03:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZI1H4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 03:56:15 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49774 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbZI1H4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 03:56:14 -0400
Date: Mon, 28 Sep 2009 16:55:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] kmemtrace: Fix up tracer registration.
Message-ID: <20090928075540.GD6668@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ddc1637af217dbd8bc51f30e6d24e84476a869a6
("kmemtrace: Print binary output only if 'bin' option is set") ended up 
inverting the error detection logic. register_tracer() returns 0 on
success, which this change caused to treat as an error, resulting in:

[    0.132000] Warning: could not register the kmem tracer

as well as bailing out of the initcall with an error value. This
restores the old logic.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>

---

 kernel/trace/kmemtrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 81b1645..a91da69 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -501,7 +501,7 @@ static int __init init_kmem_tracer(void)
 		return 1;
 	}
 
-	if (!register_tracer(&kmem_tracer)) {
+	if (register_tracer(&kmem_tracer) != 0) {
 		pr_warning("Warning: could not register the kmem tracer\n");
 		return 1;
 	}
