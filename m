Return-Path: <linux-kernel-owner+w=401wt.eu-S932354AbXHXWdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbXHXWdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 18:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760858AbXHXWd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 18:33:28 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42448 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759892AbXHXWd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 18:33:27 -0400
Subject: [2.6 patch] fix export_report.pl on top of adrian's fix
From: Ram Pai <linuxram@us.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070824214743.GH30705@stusta.de>
References: <20070824210451.GE30705@stusta.de>
	 <Pine.LNX.4.64.0708242331490.28540@fbirervta.pbzchgretzou.qr>
	 <20070824214743.GH30705@stusta.de>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 15:32:22 -0700
Message-Id: <1187994742.2910.29.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes some subtle perl coding bug observed 
by Jan Engelhardt <jengelh@computergmbh.de>
This patch applies on top of Adrian's fix.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>

---
 scripts/export_report.pl |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.21.5/scripts/export_report.pl
===================================================================
--- linux-2.6.21.5.orig/scripts/export_report.pl
+++ linux-2.6.21.5/scripts/export_report.pl
@@ -103,15 +103,15 @@ foreach my $thismod (@allcfiles) {
 	my $state=0;
 	while ( <MODULE_MODULE> ) {
 		chomp;
-		if ($state eq 0) {
+		if ($state == 0) {
 			$state = 1 if ($_ =~ /static const struct modversion_info/);
 			next;
 		}
-		if ($state eq 1) {
+		if ($state == 1) {
 			$state = 2 if ($_ =~ /__attribute__\(\(section\("__versions"\)\)\)/);
 			next;
 		}
-		if ($state eq 2) {
+		if ($state == 2) {
 			if ( $_ !~ /0x[0-9a-f]+,/ ) {
 				next;
 			}
@@ -121,7 +121,7 @@ foreach my $thismod (@allcfiles) {
 			push(@{$MODULE{$thismod}} , $sym);
 		}
 	}
-	if ($state ne 2) {
+	if ($state != 2) {
 		print "WARNING:$thismod is not built with CONFIG_MODVERSION enabled\n";
 	}
 	close(MODULE_MODULE);


