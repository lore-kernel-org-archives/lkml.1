Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbZKTPvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbZKTPvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 10:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbZKTPu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 10:50:58 -0500
Received: from mxout-08.mxes.net ([216.86.168.183]:51124 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZKTPu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 10:50:57 -0500
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: linux-kernel@vger.kernel.org, lrodriguez@atheros.com
Cc: sam@ravnborg.org, greg@kroah.com, akpm@linux-foundation.org,
       mcgrof@gmail.com, Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 1/4] kconfig: streamline_config.pl: "use strict" (and fix the errors)
Date: Fri, 20 Nov 2009 15:50:51 +0000
Message-Id: <1258732254-15573-2-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258732254-15573-1-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1258732254-15573-1-git-send-email-alan-jenkins@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Global symbol "%prompt" requires explicit package name at scripts/kconfig/streamline_config.pl line 178.
 -> Use "prompts" instead, which is what we actually declared.

Global symbol "@arr" requires explicit package name at scripts/kconfig/streamline_config.pl line 266.
 -> Declare "arr" as a local variable.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 scripts/kconfig/streamline_config.pl |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 95984db..7d898e3 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -1,4 +1,7 @@
-#!/usr/bin/perl -w
+#!/usr/bin/perl
+use strict;
+use warnings;
+
 #
 # Copywrite 2005-2009 - Steven Rostedt
 # Licensed under the terms of the GNU GPL License version 2
@@ -164,7 +167,7 @@ sub read_kconfig {
 	# configs without prompts must be selected
 	} elsif ($state ne "NONE" && /^\s*tristate\s\S/) {
 	    # note if the config has a prompt
-	    $prompt{$config} = 1;
+	    $prompts{$config} = 1;
 
 	# stop on "help"
 	} elsif (/^\s*help\s*$/) {
@@ -252,7 +255,7 @@ close (LIN);
 my %configs;
 foreach my $module (keys(%modules)) {
     if (defined($objects{$module})) {
-	@arr = @{$objects{$module}};
+	my @arr = @{$objects{$module}};
 	foreach my $conf (@arr) {
 	    $configs{$conf} = $module;
 	}
@@ -307,7 +310,7 @@ while ($repeat) {
 	    parse_config_dep_select $depends{$config};
 	}
 
-	if (defined($prompt{$config}) || !defined($selects{$config})) {
+	if (defined($prompts{$config}) || !defined($selects{$config})) {
 	    next;
 	}
 
-- 
1.6.3.3

