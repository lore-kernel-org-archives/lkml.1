Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbZAUX6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbZAUX6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 18:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbZAUX6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 18:58:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42901 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbZAUX6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:58:08 -0500
Message-Id: <20090121235806.630830270@goodmis.org>
References: <20090121235306.224764198@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 21 Jan 2009 18:53:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/5] ring-buffer: reset timestamps when ring buffer is reset
Content-Disposition: inline; filename=0005-ring-buffer-reset-timestamps-when-ring-buffer-is-re.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix bad times of recent resets

The ring buffer needs to reset its timestamps when reseting of the
buffer, otherwise the timestamps are stale and might be used to
calculate times in the buffer causing funny timestamps to appear.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index cb260dd..b36d737 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2166,6 +2166,9 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 
 	cpu_buffer->overrun = 0;
 	cpu_buffer->entries = 0;
+
+	cpu_buffer->write_stamp = 0;
+	cpu_buffer->read_stamp = 0;
 }
 
 /**
-- 
1.5.6.5

-- 
