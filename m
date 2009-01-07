Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbZAGERf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbZAGERf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 23:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZAGERD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 23:17:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55807 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbZAGERB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 23:17:01 -0500
Message-Id: <20090107041659.451444798@goodmis.org>
References: <20090107041605.168020089@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 06 Jan 2009 23:16:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Roel Kluin <roel.kluin@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v2 2/4] ring-buffer: rename debugfs file tracing_on to writing_enabled
Content-Disposition: inline; filename=0002-ring-buffer-rename-debugfs-file-tracing_on-to-writi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

The debugfs file name tracing_on is confusing since there is also
a tracing_enabled. When a tracer is added to current_tracer and
tracing_enabled is set to 1, then the tracer will start tracing.
The current file tracing_on, if set to 1, will allow writing to
the ring buffers. If tracing_on is set to 0 then the ring buffers
are read only, and any attempt by the tracers to write to the
ring buffers will fail.

But the name tracing_on confuses both developers and users.
This patch renames it to 'writing_enabled'.  This is exactly what
the file does. When set to 1, the ring buffers have writing enabled
and when set to 0, the ring buffers can not be written to.

The tracers do not get any call backs called or other notification
that the ring buffers have been set to read only, except when they
attempt to write to the ring buffers, that write will fail.

Note: it is a requirement that any tracer that uses the ring buffers
must handle a failure to write to the ring buffers, since the ring buffers
may be disabled for any number of reasons.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index a9d9760..dba6876 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2514,10 +2514,11 @@ static __init int rb_init_debugfs(void)
 
 	d_tracer = tracing_init_dentry();
 
-	entry = debugfs_create_file("tracing_on", 0644, d_tracer,
+	entry = debugfs_create_file("writing_enabled", 0644, d_tracer,
 				    &ring_buffer_flags, &rb_simple_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs 'tracing_on' entry\n");
+		pr_warning("Could not create debugfs"
+			   " 'writing_enabled' entry\n");
 
 	return 0;
 }
-- 
1.5.6.5

-- 
