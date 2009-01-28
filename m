Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZA1DbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZA1DbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 22:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZA1Day
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 22:30:54 -0500
Received: from ozlabs.org ([203.10.76.45]:36391 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbZA1Day (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 22:30:54 -0500
From: Michael Neuling <mikey@neuling.org>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, anton@samba.org
X-GPG-Fingerprint: 9B25 DC2A C58D 2C8D 47C2  457E 0887 E86F 32E6 BE16
MIME-Version: 1.0
Subject: [PATCH] bootgraph: fix for use with dot symbols
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 22.2.1
Date: Wed, 28 Jan 2009 14:30:50 +1100
Message-ID: <19599.1233113450@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powerpc has dot symbols, so the dmesg output looks like:
 
<4>[    0.327310] calling  .migration_init+0x0/0x9c @ 1
<4>[    0.327595] initcall .migration_init+0x0/0x9c returned 1 after 0 usecs

The below fixes bootgraph.pl so it handles this correctly.  

Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 scripts/bootgraph.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-ozlabs/scripts/bootgraph.pl
===================================================================
--- linux-2.6-ozlabs.orig/scripts/bootgraph.pl
+++ linux-2.6-ozlabs/scripts/bootgraph.pl
@@ -51,7 +51,7 @@ my %pidctr;
 
 while (<>) {
 	my $line = $_;
-	if ($line =~ /([0-9\.]+)\] calling  ([a-zA-Z0-9\_]+)\+/) {
+	if ($line =~ /([0-9\.]+)\] calling  ([a-zA-Z0-9\_\.]+)\+/) {
 		my $func = $2;
 		if ($done == 0) {
 			$start{$func} = $1;
@@ -87,7 +87,7 @@ while (<>) {
 		$count = $count + 1;
 	}
 
-	if ($line =~ /([0-9\.]+)\] initcall ([a-zA-Z0-9\_]+)\+.*returned/) {
+	if ($line =~ /([0-9\.]+)\] initcall ([a-zA-Z0-9\_\.]+)\+.*returned/) {
 		if ($done == 0) {
 			$end{$2} = $1;
 			$maxtime = $1;
