Return-Path: <linux-kernel-owner+w=401wt.eu-S932652AbZJ3QUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbZJ3QUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 12:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932547AbZJ3QUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 12:20:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:40608 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507AbZJ3QUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 12:20:40 -0400
Date: Fri, 30 Oct 2009 16:20:22 GMT
From: tip-bot for Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org, lihong.hi@gmail.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, lihong.hi@gmail.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20091028050703.GG30758@uhli>
References: <20091028050703.GG30758@uhli>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Move conditional into update_funcs() in recordmcount.pl
Message-ID: <tip-6092858c60f168c1950f8ad73880d54271696ec5@git.kernel.org>
Git-Commit-ID: 6092858c60f168c1950f8ad73880d54271696ec5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6092858c60f168c1950f8ad73880d54271696ec5
Gitweb:     http://git.kernel.org/tip/6092858c60f168c1950f8ad73880d54271696ec5
Author:     Li Hong <lihong.hi@gmail.com>
AuthorDate: Wed, 28 Oct 2009 13:07:03 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 29 Oct 2009 15:11:54 -0400

tracing: Move conditional into update_funcs() in recordmcount.pl

Move all the condition validations into the function update_funcs().
Also update_funcs should not die if $ref_func is undefined for there may be
more than one valid section in an object file.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
LKML-Reference: <20091028050703.GG30758@uhli>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.pl |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 7265a7d..884776a 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -348,9 +348,7 @@ my $offset = 0;		# offset of ref_func to section beginning
 #
 sub update_funcs
 {
-    return if ($#offsets < 0);
-
-    defined($ref_func) || die "No function to reference";
+    return unless ($ref_func and @offsets);
 
     # A section only had a weak function, to represent it.
     # Unfortunately, a weak function may be overwritten by another
@@ -425,7 +423,7 @@ while (<IN>) {
 	    $read_function = 0;
 	}
 	# print out any recorded offsets
-	update_funcs() if (defined($ref_func));
+	update_funcs();
 
 	# reset all markers and arrays
 	$text_found = 0;
@@ -462,7 +460,7 @@ while (<IN>) {
 }
 
 # dump out anymore offsets that may have been found
-update_funcs() if (defined($ref_func));
+update_funcs();
 
 # If we did not find any mcount callers, we are done (do nothing).
 if (!$opened) {
