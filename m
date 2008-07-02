Return-Path: <linux-kernel-owner+w=401wt.eu-S932381AbYGBLdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbYGBLdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbYGBLdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:33:20 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2920 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbYGBLdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:33:20 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 4/5] checkpatch: types cannot start mid word for pointer tests
Date: Wed,  2 Jul 2008 12:31:17 +0100
Message-Id: <1214998278-11767-5-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.1.201.g3e7d3
In-Reply-To: <1214998278-11767-1-git-send-email-apw@shadowen.org>
References: <1214998278-11767-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When checking spacing for pointer checks the type cannot start in the
middle of a word, ie. this is not 'int * bar':

	x = fooint * bar;

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 96a762b..022ee55 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1435,11 +1435,11 @@ sub process {
 			ERROR("\"(foo $1 )\" should be \"(foo $1)\"\n" .
 				$herecurr);
 
-		} elsif ($line =~ m{$NonptrType(\*+)(?:\s+(?:$Attribute|$Sparse))?\s+[A-Za-z\d_]+}) {
+		} elsif ($line =~ m{\b$NonptrType(\*+)(?:\s+(?:$Attribute|$Sparse))?\s+[A-Za-z\d_]+}) {
 			ERROR("\"foo$1 bar\" should be \"foo $1bar\"\n" .
 				$herecurr);
 
-		} elsif ($line =~ m{$NonptrType\s+(\*+)(?!\s+(?:$Attribute|$Sparse))\s+[A-Za-z\d_]+}) {
+		} elsif ($line =~ m{\b$NonptrType\s+(\*+)(?!\s+(?:$Attribute|$Sparse))\s+[A-Za-z\d_]+}) {
 			ERROR("\"foo $1 bar\" should be \"foo $1bar\"\n" .
 				$herecurr);
 		}
-- 
1.5.6.1.201.g3e7d3

