Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbYFLM26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbYFLM26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759013AbYFLM2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:28:50 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4182 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759494AbYFLM2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:28:49 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 19/23] checkpatch: possible modifiers are not being correctly matched
Date: Thu, 12 Jun 2008 13:05:58 +0100
Message-Id: <1213272362-19457-20-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although we are finding the added modifier in the declaration below
we are not correctly matching it as a type.  Fix the declaration.

    static void __ref *vmem_alloc_pages(unsigned int order)
    {
    }

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 077a2ca..53ec394 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -168,12 +168,11 @@ our @modifierList = (
 );
 
 sub build_types {
-	my $mods = "(?:  \n" . join("|\n  ", @modifierList) . "\n)";
-	my $all = "(?:  \n" . join("|\n  ", @typeList) . "\n)";
+	my $mods = "(?x:  \n" . join("|\n  ", @modifierList) . "\n)";
+	my $all = "(?x:  \n" . join("|\n  ", @typeList) . "\n)";
 	$Modifier	= qr{(?:$Attribute|$Sparse|$mods)};
 	$NonptrType	= qr{
-			(?:const\s+)?
-			(?:$mods\s+)?
+			(?:$Modifier\s+|const\s+)*
 			(?:
 				(?:typeof|__typeof__)\s*\(\s*\**\s*$Ident\s*\)|
 				(?:${all}\b)
-- 
1.5.6.rc0.140.ga9675

