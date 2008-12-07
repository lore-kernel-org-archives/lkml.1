Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbYLGSc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbYLGSc3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbYLGSbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:31:04 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:55703 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbYLGSbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:31:01 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 04/13] checkpatch: allow parentheses on return for comparisons
Date: Sun,  7 Dec 2008 18:30:41 +0000
Message-Id: <1228674650-24392-5-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1228674650-24392-1-git-send-email-apw@shadowen.org>
References: <1228674650-24392-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

It seems to be a common idiom to include braces on conditionals in all
contexts including return.  Allow this exception to the return is not
a function checks.  Reported by Kay Sievers.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b953c76..5c7fd1a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -127,6 +127,7 @@ our $Lval	= qr{$Ident(?:$Member)*};
 
 our $Constant	= qr{(?:[0-9]+|0x[0-9a-fA-F]+)[UL]*};
 our $Assignment	= qr{(?:\*\=|/=|%=|\+=|-=|<<=|>>=|&=|\^=|\|=|=)};
+our $Compare    = qr{<=|>=|==|!=|<|>};
 our $Operators	= qr{
 			<=|>=|==|!=|
 			=>|->|<<|>>|<|>|!|~|
@@ -1983,9 +1984,9 @@ sub process {
 			my $spacing = $1;
 			my $value = $2;
 
-			# Flatten any parentheses and braces
+			# Flatten any parentheses
 			$value =~ s/\)\(/\) \(/g;
-			while ($value =~ s/\([^\(\)]*\)/1/) {
+			while ($value !~ /(?:$Ident|-?$Constant)\s*$Compare\s*(?:$Ident|-?$Constant)/ && $value =~ s/\([^\(\)]*\)/1/) {
 			}
 
 			if ($value =~ /^(?:$Ident|-?$Constant)$/) {
-- 
1.6.0.4.911.gc990

