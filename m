Return-Path: <linux-kernel-owner+w=401wt.eu-S932607AbZJ3QTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbZJ3QTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 12:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932507AbZJ3QTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 12:19:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:58200 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932449AbZJ3QTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 12:19:42 -0400
Date: Fri, 30 Oct 2009 16:19:18 GMT
From: tip-bot for Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org, lihong.hi@gmail.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, lihong.hi@gmail.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20091028050332.GC30758@uhli>
References: <20091028050332.GC30758@uhli>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Check absolute path of input file in recordmcount.pl
Message-ID: <tip-bdd3b052c63b2c19a0118937f500985c01a19956@git.kernel.org>
Git-Commit-ID: bdd3b052c63b2c19a0118937f500985c01a19956
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bdd3b052c63b2c19a0118937f500985c01a19956
Gitweb:     http://git.kernel.org/tip/bdd3b052c63b2c19a0118937f500985c01a19956
Author:     Li Hong <lihong.hi@gmail.com>
AuthorDate: Wed, 28 Oct 2009 13:03:32 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 29 Oct 2009 15:11:43 -0400

tracing: Check absolute path of input file in recordmcount.pl

The ftrace.c file may reference the mcount function and this may interfere
with the recordmcount.pl processing. To avoid this, the code does not
process the kernel/trace/ftrace.o. But currently the check is against
a relative path. This patch modifies the check to succeed if the path
is an absolute path.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
LKML-Reference: <20091028050332.GC30758@uhli>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index a512af1..b80e5d0 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -123,7 +123,7 @@ my ($arch, $bits, $objdump, $objcopy, $cc,
     $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
 
 # This file refers to mcount and shouldn't be ftraced, so lets' ignore it
-if ($inputfile eq "kernel/trace/ftrace.o") {
+if ($inputfile =~ m,kernel/trace/ftrace\.o$,) {
     exit(0);
 }
 
