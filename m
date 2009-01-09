Return-Path: <linux-kernel-owner+w=401wt.eu-S1762071AbZAIA2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071AbZAIA2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 19:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756681AbZAIA2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 19:28:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51377 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbZAIA2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 19:28:42 -0500
Message-Id: <20090109002840.199851671@goodmis.org>
References: <20090109002747.240318148@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 08 Jan 2009 19:27:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] doc: mmiotrace.txt, buffer size control change
Content-Disposition: inline; filename=0001-doc-mmiotrace.txt-buffer-size-control-change.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Paalanen <pq@iki.fi>

Impact: prevents confusing the user when buffer size is inadequate

The tracing framework offers a resizeable buffer, which mmiotrace uses
to record events. If the buffer is full, the following events will be
lost. Events should not be lost, so the documentation instructs the user
to increase the buffer size. The buffer size is set via a debugfs file.

Mmiotrace documentation was not updated the same time the debugfs file
was changed. The old file was tracing/trace_entries and first contained
the number of entries the buffer had space for, per cpu. Nowadays this
file is replaced with the file tracing/buffer_size_kb, which tells the
amount of memory reserved for the buffer, per cpu, in kilobytes.

Previously, a flag had to be toggled via the debugfs file
tracing/tracing_enabled when the buffer size was changed. This is no
longer necessary.

The mmiotrace documentation is updated to reflect the current state of
the tracing framework.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 Documentation/tracers/mmiotrace.txt |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/Documentation/tracers/mmiotrace.txt b/Documentation/tracers/mmiotrace.txt
index cde23b4..5731c67 100644
--- a/Documentation/tracers/mmiotrace.txt
+++ b/Documentation/tracers/mmiotrace.txt
@@ -78,12 +78,10 @@ to view your kernel log and look for "mmiotrace has lost events" warning. If
 events were lost, the trace is incomplete. You should enlarge the buffers and
 try again. Buffers are enlarged by first seeing how large the current buffers
 are:
-$ cat /debug/tracing/trace_entries
+$ cat /debug/tracing/buffer_size_kb
 gives you a number. Approximately double this number and write it back, for
 instance:
-$ echo 0 > /debug/tracing/tracing_enabled
-$ echo 128000 > /debug/tracing/trace_entries
-$ echo 1 > /debug/tracing/tracing_enabled
+$ echo 128000 > /debug/tracing/buffer_size_kb
 Then start again from the top.
 
 If you are doing a trace for a driver project, e.g. Nouveau, you should also
-- 
1.5.6.5

-- 
