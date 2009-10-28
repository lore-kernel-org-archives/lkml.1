Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbZJ1FHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbZJ1FHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbZJ1FHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:07:09 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:39982 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344AbZJ1FHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:07:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=nhW7ELyqvrNl6Oh++R9TjItcJia3P9mn+L7EcQHD2dDRrfReD8q5eO6Q1e4on3F3eR
         Dz7Mlge+XtwDYcnMmuV4zRKSGaI+jnPJW5vsbR6MZDJ9tkXaEgPpwNT3VDSHOIC6yBKF
         f6jbZSODoORyWRg2k+HbS88G/UQsTzZbmvxRU=
Date: Wed, 28 Oct 2009 13:07:03 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 7/8] tracing: recordmcount.pl Combine the condition
	validation in update_funcs
Message-ID: <20091028050703.GG30758@uhli>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
References: <20091028045532.GA30036@uhli>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028045532.GA30036@uhli>
X-Operating-System: Linux uhli 2.6.28-11-generic 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c40f78d26c171732e6b3546d1f2141274a48c42b Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Tue, 27 Oct 2009 13:20:48 +0800
Subject: [PATCH] tracing: recordmcount.pl Combine the condition validation in update_funcs

Move all the condition validation into function update_funcs. Also
update_funcs shouldn't die if $ref_func is undefined for there may be
more than one valid sections in an object file.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 scripts/recordmcount.pl |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 0f1107d..ffb1123 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -346,9 +346,7 @@ my $offset = 0;		# offset of ref_func to section beginning
 #
 sub update_funcs
 {
-    return if ($#offsets < 0);
-
-    defined($ref_func) || die "No function to reference";
+    return unless ($ref_func and @offsets);
 
     # A section only had a weak function, to represent it.
     # Unfortunately, a weak function may be overwritten by another
@@ -423,7 +421,7 @@ while (<IN>) {
 	    $read_function = 0;
 	}
 	# print out any recorded offsets
-	update_funcs() if (defined($ref_func));
+	update_funcs();
 
 	# reset all markers and arrays
 	$text_found = 0;
@@ -460,7 +458,7 @@ while (<IN>) {
 }
 
 # dump out anymore offsets that may have been found
-update_funcs() if (defined($ref_func));
+update_funcs();
 
 # If we did not find any mcount callers, we are done (do nothing).
 if (!$opened) {
-- 
1.6.0.4

