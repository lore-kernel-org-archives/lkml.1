Return-Path: <linux-kernel-owner+w=401wt.eu-S1423111AbXBPEFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423111AbXBPEFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 23:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423126AbXBPEFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 23:05:41 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:62640 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423111AbXBPEFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 23:05:40 -0500
Date: Thu, 15 Feb 2007 23:05:38 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@redhat.com>, systemtap@sources.redhat.com,
       ltt-dev@shafik.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Linux Kernel Markers Documentation - fix
Message-ID: <20070216040538.GC16075@Krystal>
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214231201.20918c6b.akpm@linux-foundation.org> <20070216013348.GC12736@Krystal> <20070215174500.2b1b3bb9.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070215174500.2b1b3bb9.randy.dunlap@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 22:56:05 up 13 days, 18:04,  5 users,  load average: 1.08, 1.07, 1.06
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Markers Documentation - fix

Fixes from Randy's comments.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/Documentation/marker.txt
+++ b/Documentation/marker.txt
@@ -18,7 +18,7 @@ code is reached.
 
 They can be used for tracing (LTTng, LKET over SystemTAP), overall performance
 accounting (SystemTAP). They could also be used to implement
-efficient hooks for SELinux or any other subsystem the would have this
+efficient hooks for SELinux or any other subsystem that would have this
 kind of need.
 
 Using the markers for system audit (SELinux) would require to pass a
@@ -30,8 +30,9 @@ variable by address that would be later checked by the marked routine.
 MARK(subsystem_event, "%d %s %p[struct task_struct]",
   someint, somestring, current);
 Where :
-- Subsystem is the name of your subsystem.
-- event is the name of the event to mark.
+- subsystem_event is an identifier unique to your event
+    - subsystem is the name of your subsystem.
+    - event is the name of the event to mark.
 - "%d %s %p[struct task_struct]" is the formatted string for (printk-style).
 - someint is an integer.
 - somestring is a char pointer.
@@ -39,7 +40,7 @@ Where :
 
 The expression %p[struct task_struct] is a suggested marker definition
 standard that could eventually be used for pointer type checking in
-sparse. The brackets contain the type to which the pointer refer.
+sparse. The brackets contain the type to which the pointer refers.
 
 The marker mechanism supports multiple instances of the same marker.
 Markers can be put in inline functions, inlined static functions and
@@ -104,8 +105,8 @@ static int __init probe_init(void)
 {
 	int result;
 	result = marker_set_probe("subsystem_event",
-			FS_CLOSE_FORMAT,
-			probe_fs_close);
+			SUBSYSTEM_EVENT_FORMAT,
+			probe_subsystem_event);
 	if (!result)
 		goto cleanup;
 	return 0;
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
