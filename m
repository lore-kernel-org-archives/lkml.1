Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYJCP2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYJCP2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYJCP0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:26:08 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:57518 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbYJCP0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:26:01 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 08/13] checkpatch: complex macros checks miss square brackets
Date: Fri,  3 Oct 2008 16:25:49 +0100
Message-Id: <1223047554-31111-9-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.1.451.gc8d31
In-Reply-To: <1223047554-31111-1-git-send-email-apw@shadowen.org>
References: <1223047554-31111-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are missing 'simple' values which include square brackets.  Refactor
to ensure we handle nesting correctly and detect these simple forms.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c479bde..54dfa2b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2142,9 +2142,10 @@ sub process {
 			$dstat =~ s/\s*$//s;
 
 			# Flatten any parentheses and braces
-			while ($dstat =~ s/\([^\(\)]*\)/1/) {
-			}
-			while ($dstat =~ s/\{[^\{\}]*\}/1/) {
+			while ($dstat =~ s/\([^\(\)]*\)/1/ ||
+			       $dstat =~ s/\{[^\{\}]*\}/1/ ||
+			       $dstat =~ s/\[[^\{\}]*\]/1/)
+			{
 			}
 
 			my $exceptions = qr{
-- 
1.6.0.1.451.gc8d31

