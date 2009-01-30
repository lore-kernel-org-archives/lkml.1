Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbZA3PHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbZA3PHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 10:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbZA3PFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 10:05:36 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60181 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbZA3PFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 10:05:34 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 5/8] checkpatch: a modifier is not an identifier at the end of a type
Date: Fri, 30 Jan 2009 15:05:17 +0000
Message-Id: <1233327920-16691-6-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.1.2.419.g0d87e
In-Reply-To: <1233327920-16691-1-git-send-email-apw@canonical.com>
References: <1233327920-16691-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must make sure we do not miss recognise a modifier as an Identifier
when trying to match types.  Prevent us matching this:

	void * __ref

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 15a5904..b9e9ee1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1686,8 +1686,8 @@ sub process {
 			# Modifiers should have spaces.
 			$to =~ s/(\b$Modifier$)/$1 /;
 
-			#print "from<$from> to<$to>\n";
-			if ($from ne $to) {
+			#print "from<$from> to<$to> ident<$ident>\n";
+			if ($from ne $to && $ident !~ /^$Modifier$/) {
 				ERROR("\"foo${from}bar\" should be \"foo${to}bar\"\n" .  $herecurr);
 			}
 		}
-- 
1.6.1.2.419.g0d87e

