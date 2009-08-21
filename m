Return-Path: <linux-kernel-owner+w=401wt.eu-S933111AbZHUVq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111AbZHUVq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933016AbZHUVqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:46:55 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59347 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940AbZHUVqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:46:25 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/7] checkpatch: possible types -- else cannot start a type
Date: Fri, 21 Aug 2009 22:46:04 +0100
Message-Id: <1250891170-8599-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1250891170-8599-1-git-send-email-apw@canonical.com>
References: <1250891170-8599-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An else cannot start a type, it would have to be within a block after
the else.  This can trigger false modifier matching.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2d5ece7..fd64816 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1372,6 +1372,8 @@ sub process {
 			# Ignore functions being called
 			} elsif ($s =~ /^.\s*$Ident\s*\(/s) {
 
+			} elsif ($s =~ /^.\s*else\b/s) {
+
 			# declarations always start with types
 			} elsif ($prev_values eq 'E' && $s =~ /^.\s*(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?((?:\s*$Ident)+?)\b(?:\s+$Sparse)?\s*\**\s*(?:$Ident|\(\*[^\)]*\))(?:\s*$Modifier)?\s*(?:;|=|,|\()/s) {
 				my $type = $1;
-- 
1.6.3.3

