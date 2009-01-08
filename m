Return-Path: <linux-kernel-owner+w=401wt.eu-S1761394AbZAHWN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761394AbZAHWN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZAHWNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:13:49 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:22044 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZAHWNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:13:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Go8V3DHgHnlqfLHU97VwrFO7rMbGhwWQm7w1unUJvcpZz+9ZcUN3esjAct/3PG55DD
         bggfFHu+aT1Z9hpWe51yWu2EbTVjXDS4j5AT/9iRY8t+AbPCwAQQE1w+zuk1aDZz6kVl
         Hu9ZpRsxiBNuusrOEGNzHvi84Oav1YxnBE+QU=
Date: Fri, 9 Jan 2009 00:13:41 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, pq@iki.fi
Subject: [PATCH v2 1/3] doc: mmiotrace.txt, buffer size control change
Message-ID: <20090109001341.6ea77e98@daedalus.pq.iki.fi>
In-Reply-To: <alpine.DEB.1.10.0901081538080.28112@gandalf.stny.rr.com>
References: <20090108223255.6f29f1cf@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0901081538080.28112@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 297ddd1d79f7826bdd058b1bfd580dcaf97d3946 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sat, 3 Jan 2009 21:09:27 +0200
Subject: [PATCH] doc: mmiotrace.txt, buffer size control change

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
1.6.0.6

