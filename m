Return-Path: <linux-kernel-owner+w=401wt.eu-S1757671AbYHKUNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671AbYHKUNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbYHKUNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:13:19 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41160 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbYHKUNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:13:18 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 02/17] checkpatch: values: double ampersand may be unary
Date: Mon, 11 Aug 2008 21:12:57 +0100
Message-Id: <1218485592-6679-3-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1218485592-6679-1-git-send-email-apw@shadowen.org>
References: <1218485592-6679-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to use double ampersand (&&) in unary context where it
means the address of a goto label.  Handle spacing for it.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 6f821a0..1148213 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -858,7 +858,7 @@ sub annotate_values {
 			print "CLOSE($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
-		} elsif ($cur =~ /^(-(?![->])|\+(?!\+)|\*|\&(?!\&))/o) {
+		} elsif ($cur =~ /^(-(?![->])|\+(?!\+)|\*|\&\&|\&)/o) {
 			my $variant;
 
 			print "OPV($1)\n" if ($dbg_values > 1);
@@ -1634,7 +1634,7 @@ sub process {
 				# unary operator, or a cast
 				} elsif ($op eq '!' || $op eq '~' ||
 					 $opv eq '*U' || $opv eq '-U' ||
-					 $opv eq '&U') {
+					 $opv eq '&U' || $opv eq '&&U') {
 					if ($ctx !~ /[WEBC]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
 						ERROR("space required before that '$op' $at\n" . $hereptr);
 					}
-- 
1.6.0.rc1.258.g80295

