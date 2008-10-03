Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbYJCP1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbYJCP1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYJCP0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:26:05 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:57503 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbYJCP0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:26:00 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 06/13] checkpatch: pull out known acceptable typedefs
Date: Fri,  3 Oct 2008 16:25:47 +0100
Message-Id: <1223047554-31111-7-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.1.451.gc8d31
In-Reply-To: <1223047554-31111-1-git-send-email-apw@shadowen.org>
References: <1223047554-31111-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Within the type checker we have a number of common kernel types which
must be implemented as typedefs.  Pull those out so that we can use
the same expressions to trigger exclusions.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bb88df2..4680ccf 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -146,6 +146,11 @@ our $UTF8	= qr {
 	|  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
 }x;
 
+our $typeTypedefs = qr{(?x:
+	(?:__)?(?:u|s|be|le)(?:\d|\d\d)|
+	atomic_t
+)};
+
 our @typeList = (
 	qr{void},
 	qr{(?:unsigned\s+)?char},
@@ -159,7 +164,6 @@ our @typeList = (
 	qr{float},
 	qr{double},
 	qr{bool},
-	qr{(?:__)?(?:u|s|be|le)(?:\d|\d\d)},
 	qr{struct\s+$Ident},
 	qr{union\s+$Ident},
 	qr{enum\s+$Ident},
@@ -179,6 +183,7 @@ sub build_types {
 			(?:$Modifier\s+|const\s+)*
 			(?:
 				(?:typeof|__typeof__)\s*\(\s*\**\s*$Ident\s*\)|
+				(?:$typeTypedefs\b)|
 				(?:${all}\b)
 			)
 			(?:\s+$Modifier|\s+const)*
@@ -1589,6 +1594,7 @@ sub process {
 		if ($line =~ /\btypedef\s/ &&
 		    $line !~ /\btypedef\s+$Type\s+\(\s*\*?$Ident\s*\)\s*\(/ &&
 		    $line !~ /\btypedef\s+$Type\s+$Ident\s*\(/ &&
+		    $line !~ /\b$typeTypedefs\b/ &&
 		    $line !~ /\b__bitwise(?:__|)\b/) {
 			WARN("do not add new typedefs\n" . $herecurr);
 		}
-- 
1.6.0.1.451.gc8d31

