Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbYANTWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbYANTWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYANTWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:22:43 -0500
Received: from mail.vyatta.com ([216.93.170.194]:33692 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYANTWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:22:42 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.507
Date: Mon, 14 Jan 2008 11:19:34 -0800
From: Stephen Hemminger <stephen.hemminger@vyatta.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] checkstack: fix perl warnings
Message-ID: <20080114111934.0460c736@deepthought>
In-Reply-To: <20080114111602.591fe1a4@deepthought>
References: <20080114111602.591fe1a4@deepthought>
Organization: Vyatta
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you enable perl warnings on this script, it shows a couple of problems:
	
  Parentheses missing around "my" list at scripts/checkstack.pl line 105.
  Useless use of a variable in void context at scripts/checkstack.pl line 105.
  Use of uninitialized value in string eq at scripts/checkstack.pl line 33.

Signed-off-by: Stephen Hemminger <stephen.hemminger@vyatta.com>

--- a/scripts/checkstack.pl	2008-01-14 11:10:57.000000000 -0800
+++ b/scripts/checkstack.pl	2008-01-14 11:11:56.000000000 -0800
@@ -30,7 +30,7 @@
 my (@stack, $re, $x, $xs);
 {
 	my $arch = shift;
-	if ($arch eq "") {
+	if (! defined $arch) {
 		$arch = `uname -m`;
 		chomp $arch;
 	}
@@ -102,7 +102,8 @@ sub bysize($) {
 #
 my $funcre = qr/^$x* <(.*)>:$/;
 my $func;
-my $file, $lastslash;
+my $file;
+my $lastslash;
 
 while (my $line = <STDIN>) {
 	if ($line =~ m/$funcre/) {
