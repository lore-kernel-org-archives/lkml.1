Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab0CJIYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 03:24:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34580 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab0CJIYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 03:24:06 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Joe Perches <joe@perches.com>
Date: Wed, 10 Mar 2010 05:19:59 +0100
Message-Id: <1268194799-16375-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH] get_maintainer: Repair STDIN usage
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 22dd5b0cba50a197aaa3bd2790a29ee2e8e4e372 (fix perlcritic warnings) broke
the ability to handle STDIN because the three argument version of open() cannot
handle standard IO-streams (which is mentioned in PerlBestPractices, too).

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Joe Perches <joe@perches.com>
---

Like checkpatch, the hints from perlcritic should be double-checked ;)

 scripts/get_maintainer.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index f76f3d1..6f97a13 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -284,7 +284,7 @@ foreach my $file (@ARGV) {
 	my $file_cnt = @files;
 	my $lastfile;
 
-	open(my $patch, '<', $file)
+	open(my $patch, "< $file")
 	    or die "$P: Can't open $file: $!\n";
 	while (<$patch>) {
 	    my $patch_line = $_;
-- 
1.7.0

