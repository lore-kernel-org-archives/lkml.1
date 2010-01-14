Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811Ab0ANClx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab0ANClx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500Ab0ANClx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:41:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38818 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab0ANClw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:41:52 -0500
X-Authority-Analysis: v=1.0 c=1 a=oFs2KZS6xo0A:10 a=3bJliv6G_HsUD0pOxmkA:9 a=iwaMzISIgRZOXNkw9wBeLoW6eLsA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Date: Wed, 13 Jan 2010 21:41:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Wenji Huang <wenji.huang@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: tracing: Multi definition of TRACE_INCLUDE_FILE
Message-ID: <20100114024147.GB15301@goodmis.org>
References: <4B443E78.7040704@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B443E78.7040704@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 03:40:40PM +0800, Wenji Huang wrote:
> Hi,
> 
> There are multi definition of TRACE_INCLUDE_FILE on
> include/trace/events/{syscalls, kvm}.h
> It will result in compilation error when some
> out-of-tree tools like Systemtap processes kernel
> tracepoints in a way to put header files into module.
> 

Does the following patch fix your issues?

-- Steve


diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index dbe1084..532d658 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -4,6 +4,7 @@
 #include <linux/tracepoint.h>
 
 #undef TRACE_SYSTEM
+#undef TRACE_INCLUDE_FILE
 #define TRACE_SYSTEM kvm
 #define TRACE_INCLUDE_FILE kvm
 
diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
index fb726ac..52290bb 100644
--- a/include/trace/events/syscalls.h
+++ b/include/trace/events/syscalls.h
@@ -1,4 +1,5 @@
 #undef TRACE_SYSTEM
+#undef TRACE_INCLUDE_FILE
 #define TRACE_SYSTEM raw_syscalls
 #define TRACE_INCLUDE_FILE syscalls
 
