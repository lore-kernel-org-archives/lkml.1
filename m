Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbZALMq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbZALMq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZALMpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:45:19 -0500
Received: from adelie.canonical.com ([91.189.90.139]:40858 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbZALMpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:45:18 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 3/6] checkpatch: allow parentheses on return handle array values
Date: Mon, 12 Jan 2009 12:45:01 +0000
Message-Id: <1231764304-1491-4-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1231764304-1491-1-git-send-email-apw@canonical.com>
References: <1231764304-1491-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we allow return to have surrounding parentheses when containing
comparison operators we are not correctly handling the case where
the values contain array sufffixes.  Squash them.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 1d7924a..696196e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2016,7 +2016,11 @@ sub process {
 
 			# Flatten any parentheses
 			$value =~ s/\)\(/\) \(/g;
-			while ($value !~ /(?:$Ident|-?$Constant)\s*$Compare\s*(?:$Ident|-?$Constant)/ && $value =~ s/\([^\(\)]*\)/1/) {
+			while ($value =~ s/\[[^\{\}]*\]/1/ ||
+			       $value !~ /(?:$Ident|-?$Constant)\s*
+					     $Compare\s*
+					     (?:$Ident|-?$Constant)/x &&
+			       $value =~ s/\([^\(\)]*\)/1/) {
 			}
 
 			if ($value =~ /^(?:$Ident|-?$Constant)$/) {
-- 
1.6.0.4.911.gc990

