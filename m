Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbYHKUOC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbYHKUOC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:14:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYHKUNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:13:20 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41150 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbYHKUNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:13:18 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 05/17] checkpatch: add tests for the attribute matcher
Date: Mon, 11 Aug 2008 21:13:00 +0100
Message-Id: <1218485592-6679-6-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1218485592-6679-1-git-send-email-apw@shadowen.org>
References: <1218485592-6679-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for direct testing of the attribute matcher, add basic tests
for it.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c6782ac..1c032b1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -66,6 +66,7 @@ if ($#ARGV < 0) {
 my $dbg_values = 0;
 my $dbg_possible = 0;
 my $dbg_type = 0;
+my $dbg_attr = 0;
 for my $key (keys %debug) {
 	eval "\${dbg_$key} = '$debug{$key}';"
 }
@@ -1367,6 +1368,15 @@ sub process {
 			}
 			next;
 		}
+# TEST: allow direct testing of the attribute matcher.
+		if ($dbg_attr) {
+			if ($line =~ /^.\s*$Attribute\s*$/) {
+				ERROR("TEST: is attr\n" . $herecurr);
+			} elsif ($dbg_attr > 1 && $line =~ /^.+($Attribute)/) {
+				ERROR("TEST: is not attr ($1 is)\n". $herecurr);
+			}
+			next;
+		}
 
 # check for initialisation to aggregates open brace on the next line
 		if ($prevline =~ /$Declare\s*$Ident\s*=\s*$/ &&
-- 
1.6.0.rc1.258.g80295

