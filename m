Return-Path: <linux-kernel-owner+w=401wt.eu-S932775AbZHUU6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775AbZHUU6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932686AbZHUU6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:58:49 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:37704 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbZHUU6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:58:48 -0400
Date: Fri, 21 Aug 2009 14:00:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] tracing/syscalls: fix printk formats
Message-Id: <20090821140020.c4140ca9.randy.dunlap@oracle.com>
In-Reply-To: <20090821164140.71968b47.sfr@canb.auug.org.au>
References: <20090821164140.71968b47.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4A8F0A79.01A5:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings:

kernel/trace/trace_syscalls.c:113: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
kernel/trace/trace_syscalls.c:123: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/trace/trace_syscalls.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20090821.orig/kernel/trace/trace_syscalls.c
+++ linux-next-20090821/kernel/trace/trace_syscalls.c
@@ -109,7 +109,7 @@ int ftrace_format_syscall(struct ftrace_
 				        entry->args[i]);
 		if (!ret)
 			return 0;
-		ret = trace_seq_printf(s, "\toffset:%d;\tsize:%lu;\n", offset,
+		ret = trace_seq_printf(s, "\toffset:%d;\tsize:%zu;\n", offset,
 				       sizeof(unsigned long));
 		if (!ret)
 			return 0;
@@ -118,7 +118,7 @@ int ftrace_format_syscall(struct ftrace_
 
 	trace_seq_printf(s, "\nprint fmt: \"");
 	for (i = 0; i < entry->nb_args; i++) {
-		ret = trace_seq_printf(s, "%s: 0x%%0%lulx%s", entry->args[i],
+		ret = trace_seq_printf(s, "%s: 0x%%0%zulx%s", entry->args[i],
 				        sizeof(unsigned long),
 					i == entry->nb_args - 1 ? "\", " : ", ");
 		if (!ret)



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
