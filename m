Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbZLSASP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbZLSASP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 19:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbZLSASH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 19:18:07 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:56698 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbZLSARt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 19:17:49 -0500
Message-ID: <4B2C0D78.6060707@oracle.com>
Date: Fri, 18 Dec 2009 15:17:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/4] Documentation: update ftrace-design.txt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B2C1BA1.0055:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Correct grammos.  Spell out words.  Add missing words.
Consistent use of "mcount()" function name.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace-design.txt |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- lnx-2633-rc1.orig/Documentation/trace/ftrace-design.txt
+++ lnx-2633-rc1/Documentation/trace/ftrace-design.txt
@@ -53,14 +53,14 @@ size of the mcount call that is embedded
 For example, if the function foo() calls bar(), when the bar() function calls
 mcount(), the arguments mcount() will pass to the tracer are:
 	"frompc" - the address bar() will use to return to foo()
-	"selfpc" - the address bar() (with _mcount() size adjustment)
+	"selfpc" - the address bar() (with mcount() size adjustment)
 
 Also keep in mind that this mcount function will be called *a lot*, so
 optimizing for the default case of no tracer will help the smooth running of
 your system when tracing is disabled.  So the start of the mcount function is
-typically the bare min with checking things before returning.  That also means
-the code flow should usually kept linear (i.e. no branching in the nop case).
-This is of course an optimization and not a hard requirement.
+typically the bare minimum with checking things before returning.  That also
+means the code flow should usually be kept linear (i.e. no branching in the nop
+case).  This is of course an optimization and not a hard requirement.
 
 Here is some pseudo code that should help (these functions should actually be
 implemented in assembly):
@@ -131,10 +131,10 @@ some functions to save (hijack) and rest
 
 The mcount function should check the function pointers ftrace_graph_return
 (compare to ftrace_stub) and ftrace_graph_entry (compare to
-ftrace_graph_entry_stub).  If either of those are not set to the relevant stub
+ftrace_graph_entry_stub).  If either of those is not set to the relevant stub
 function, call the arch-specific function ftrace_graph_caller which in turn
 calls the arch-specific function prepare_ftrace_return.  Neither of these
-function names are strictly required, but you should use them anyways to stay
+function names is strictly required, but you should use them anyway to stay
 consistent across the architecture ports -- easier to compare & contrast
 things.
 
@@ -144,7 +144,7 @@ but the first argument should be a point
 located on the stack.  This allows the function to hijack the return address
 temporarily to have it point to the arch-specific function return_to_handler.
 That function will simply call the common ftrace_return_to_handler function and
-that will return the original return address with which, you can return to the
+that will return the original return address with which you can return to the
 original call site.
 
 Here is the updated mcount pseudo code:

