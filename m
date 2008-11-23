Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbYKWTZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbYKWTZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYKWTZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:25:07 -0500
Received: from ik-out-1112.google.com ([66.249.90.178]:8891 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbYKWTZF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:25:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=a2bESSPyB6G6ltp85xQbBAXaJ68tq3xxj6JZuk83tvOOixzlNra/dcNuvV97UceEc8
         IQaUnGwyIWhWURbLDE0vHaDNchrxzgg/qrtYAnxJjqO/SLRJ5cnDQODbfigdTUrgleBK
         mssk8VMgMrvyrwwv7J6ZcktX+Zt8i36io8AWM=
Date: Sun, 23 Nov 2008 21:24:59 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
Subject: [PATCH 2/2] doc: update mmiotrace documentation
Message-ID: <20081123212459.75f0ca2d@daedalus.pq.iki.fi>
In-Reply-To: <alpine.DEB.1.10.0811231134150.27108@gandalf.stny.rr.com>
References: <20081123154148.04e0851a@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0811231134150.27108@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9fac48964c6d109589c9d610a727f72d2a1835dc Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sun, 23 Nov 2008 20:59:56 +0200
Subject: [PATCH] doc: update mmiotrace documentation

Update to reflect the current state of the tracing framework:
- "none" tracer has been replaced by "nop" tracer
- tracing_enabled must be toggled when changing buffer size

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 Documentation/tracers/mmiotrace.txt |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/tracers/mmiotrace.txt b/Documentation/tracers/mmiotrace.txt
index 5bbbe20..cde23b4 100644
--- a/Documentation/tracers/mmiotrace.txt
+++ b/Documentation/tracers/mmiotrace.txt
@@ -37,7 +37,7 @@ $ echo mmiotrace > /debug/tracing/current_tracer
 $ cat /debug/tracing/trace_pipe > mydump.txt &
 Start X or whatever.
 $ echo "X is up" > /debug/tracing/trace_marker
-$ echo none > /debug/tracing/current_tracer
+$ echo nop > /debug/tracing/current_tracer
 Check for lost events.
 
 
@@ -66,7 +66,7 @@ which action. It is recommended to place descriptive markers about what you
 do.
 
 Shut down mmiotrace (requires root privileges):
-$ echo none > /debug/tracing/current_tracer
+$ echo nop > /debug/tracing/current_tracer
 The 'cat' process exits. If it does not, kill it by issuing 'fg' command and
 pressing ctrl+c.
 
@@ -81,7 +81,9 @@ are:
 $ cat /debug/tracing/trace_entries
 gives you a number. Approximately double this number and write it back, for
 instance:
+$ echo 0 > /debug/tracing/tracing_enabled
 $ echo 128000 > /debug/tracing/trace_entries
+$ echo 1 > /debug/tracing/tracing_enabled
 Then start again from the top.
 
 If you are doing a trace for a driver project, e.g. Nouveau, you should also
-- 
1.5.6.4

