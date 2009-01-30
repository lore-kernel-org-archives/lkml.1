Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbZA3PFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbZA3PFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 10:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbZA3PFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 10:05:32 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60148 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZA3PFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 10:05:31 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 3/8] checkpatch: correctly handle type spacing in the face of modifiers
Date: Fri, 30 Jan 2009 15:05:15 +0000
Message-Id: <1233327920-16691-4-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.1.2.419.g0d87e
In-Reply-To: <1233327920-16691-1-git-send-email-apw@canonical.com>
References: <1233327920-16691-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to handle interspersed modifiers in the middle of pointer types,
for example:

	void * __user * __user bar;

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 5ffc940..92d1371 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1658,7 +1658,7 @@ sub process {
 
 # * goes on variable not on type
 		# (char*[ const])
-		if ($line =~ m{\($NonptrType(\s*\*[\s\*]*(?:$Modifier\s*)*)\)}) {
+		if ($line =~ m{\($NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)\)}) {
 			my ($from, $to) = ($1, $1);
 
 			# Should start with a space.
@@ -1673,7 +1673,7 @@ sub process {
 			if ($from ne $to) {
 				ERROR("\"(foo$from)\" should be \"(foo$to)\"\n" .  $herecurr);
 			}
-		} elsif ($line =~ m{\b$NonptrType(\s*\*[\s\*]*(?:$Modifier\s*)?)($Ident)}) {
+		} elsif ($line =~ m{\b$NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)($Ident)}) {
 			my ($from, $to, $ident) = ($1, $1, $2);
 
 			# Should start with a space.
-- 
1.6.1.2.419.g0d87e

