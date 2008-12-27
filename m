Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbYL0HzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbYL0HzO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 02:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbYL0HzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 02:55:00 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:36676 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYL0HzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 02:55:00 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] headers_install.pl: autoconvert asm/inline/volatile to __xxx__
Date: Sat, 27 Dec 2008 02:54:58 -0500
Message-Id: <1230364498-31620-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Headers in userspace should be using the __xxx__ form of the asm, inline,
and volatile keywords.  Since people like to revert these things without
realizing what's going on, have the headers install step autoconvert these
keywords.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 scripts/headers_install.pl |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
index 7d2b414..b450aec 100644
--- a/scripts/headers_install.pl
+++ b/scripts/headers_install.pl
@@ -36,6 +36,7 @@ foreach my $file (@files) {
 		$line =~ s/\s__attribute_const__\s/ /g;
 		$line =~ s/\s__attribute_const__$//g;
 		$line =~ s/^#include <linux\/compiler.h>//;
+		$line =~ s/(^|\s)(asm|inline|volatile)(\s|[(]|$)\b/$1__$2__$3/;
 		printf OUTFILE "%s", $line;
 	}
 	close OUTFILE;
-- 
1.6.0.6

