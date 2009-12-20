Return-Path: <linux-kernel-owner+w=401wt.eu-S1751824AbZLTFXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbZLTFXB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 00:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZLTFW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 00:22:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:55656 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbZLTFW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 00:22:57 -0500
Date: Sun, 20 Dec 2009 05:22:11 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, randy.dunlap@oracle.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, randy.dunlap@oracle.com,
       mingo@elte.hu
In-Reply-To: <4B2C0D78.6060707@oracle.com>
References: <4B2C0D78.6060707@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] Documentation: Update ftrace-design.txt
Message-ID: <tip-7e25f44cbf8d95a9748fdfd19c06145f19fd10e3@git.kernel.org>
Git-Commit-ID: 7e25f44cbf8d95a9748fdfd19c06145f19fd10e3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e25f44cbf8d95a9748fdfd19c06145f19fd10e3
Gitweb:     http://git.kernel.org/tip/7e25f44cbf8d95a9748fdfd19c06145f19fd10e3
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Fri, 18 Dec 2009 15:17:12 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Dec 2009 06:18:25 +0100

Documentation: Update ftrace-design.txt

Correct grammos.  Spell out words.  Add missing words.
Consistent use of "mcount()" function name.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4B2C0D78.6060707@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/trace/ftrace-design.txt |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index 641a1ef..239f14b 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -53,14 +53,14 @@ size of the mcount call that is embedded in the function).
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
@@ -131,10 +131,10 @@ some functions to save (hijack) and restore the return address.
 
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
 
@@ -144,7 +144,7 @@ but the first argument should be a pointer to the "frompc".  Typically this is
 located on the stack.  This allows the function to hijack the return address
 temporarily to have it point to the arch-specific function return_to_handler.
 That function will simply call the common ftrace_return_to_handler function and
-that will return the original return address with which, you can return to the
+that will return the original return address with which you can return to the
 original call site.
 
 Here is the updated mcount pseudo code:
