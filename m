Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYL2LMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYL2LMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYL2LMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:12:36 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:36724 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbYL2LMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:12:35 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] kbuild: auto-convert size types in userspace headers
Date: Mon, 29 Dec 2008 06:12:33 -0500
Message-Id: <1230549153-31754-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <49567EB5.5030409@zytor.com>
References: <49567EB5.5030409@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than constantly fixing up size type breakage in userspace headers,
auto convert the types u_intXX_t, uintXX_t, intXX_t, uXX, and sXX to the
appropriate __uXX or __sXX type.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 scripts/headers_install.pl |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
index c6ae405..697f02d 100644
--- a/scripts/headers_install.pl
+++ b/scripts/headers_install.pl
@@ -39,6 +39,9 @@ foreach my $file (@files) {
 		$line =~ s/(^|\s)(inline)\b/$1__$2__/g;
 		$line =~ s/(^|\s)(asm)\b(\s|[(]|$)/$1__$2__$3/g;
 		$line =~ s/(^|\s|[(])(volatile)\b(\s|[(]|$)/$1__$2__$3/g;
+		$line =~ s/\b([us](8|16|32|64))\b/__$1/g;
+		$line =~ s/\b(u_?int(8|16|32|64)_t)\b/__u$2/g;
+		$line =~ s/\b(int(8|16|32|64)_t)\b/__s$2/g;
 		printf OUTFILE "%s", $line;
 	}
 	close OUTFILE;
-- 
1.6.0.6

