Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbZALMqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbZALMqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbZALMpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:45:16 -0500
Received: from adelie.canonical.com ([91.189.90.139]:40738 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbZALMpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:45:14 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 2/6] checkpatch: type/cast spacing should not check prefix spacing
Date: Mon, 12 Jan 2009 12:45:00 +0000
Message-Id: <1231764304-1491-3-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1231764304-1491-1-git-send-email-apw@canonical.com>
References: <1231764304-1491-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not be complaining about the prefix spacing for types and
casts.  We are triggering here because the check for spacing between
'*'s is overly loose.  Tighten this up.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index eefef65..1d7924a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1665,7 +1665,7 @@ sub process {
 			# Should not end with a space.
 			$to =~ s/\s+$//;
 			# '*'s should not have spaces between.
-			while ($to =~ s/(.)\s\*/$1\*/) {
+			while ($to =~ s/\*\s+\*/\*\*/) {
 			}
 
 			#print "from<$from> to<$to>\n";
@@ -1680,7 +1680,7 @@ sub process {
 			# Should not end with a space.
 			$to =~ s/\s+$//;
 			# '*'s should not have spaces between.
-			while ($to =~ s/(.)\s\*/$1\*/) {
+			while ($to =~ s/\*\s+\*/\*\*/) {
 			}
 			# Modifiers should have spaces.
 			$to =~ s/(\b$Modifier$)/$1 /;
-- 
1.6.0.4.911.gc990

