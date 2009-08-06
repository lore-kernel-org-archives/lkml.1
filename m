Return-Path: <linux-kernel-owner+w=401wt.eu-S1753777AbZHFCn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbZHFCn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 22:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbZHFCn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 22:43:56 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3242 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZHFCnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 22:43:52 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>,
       Greg KH <greg@kroah.com>
Subject: [PATCH 6/7] scripts/get_maintainer.pl: Using --separator implies --nomultiline
Date: Wed,  5 Aug 2009 19:43:47 -0700
Message-Id: <86324cf3102c4b35f1b51586cd27d0af5095509a.1249525834.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1249525834.git.joe@perches.com>
References: <cover.1249525834.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a person sets a separator, it's only used if --nomultiline is set.
Don't make the command line also include --nomultiline in that case.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 1422bf3..a0ccc72 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -105,6 +105,10 @@ if ($#ARGV < 0) {
     die "$P: argument missing: patchfile or -f file please\n";
 }
 
+if ($output_separator ne ", ") {
+    $output_multiline = 0;
+}
+
 my $selections = $email + $scm + $status + $subsystem + $web;
 if ($selections == 0) {
     usage();
@@ -376,6 +380,7 @@ MAINTAINER field selection options:
 
 Output type options:
   --separator [, ] => separator for multiple entries on 1 line
+    using --separator also sets --nomultiline if --separator is not [, ]
   --multiline => print 1 entry per line
 
 Other options:
-- 
1.6.3.1.10.g659a0.dirty

