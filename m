Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbYL2NxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbYL2NxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbYL2Nvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:51:54 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:36143 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbYL2Nvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:51:50 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 10/13] kbuild: in headers_install autoconvert asm/inline/volatile to __xxx__
Date: Mon, 29 Dec 2008 14:53:20 +0100
Message-Id: <1230558803-7168-10-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081229134402.GA7069@uranus.ravnborg.org>
References: <20081229134402.GA7069@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

Headers in userspace should be using the __xxx__ form of the asm, inline,
and volatile keywords.  Since people like to revert these things without
realizing what's going on, have the headers install step autoconvert these
keywords.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/headers_install.pl |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
index 7d2b414..c6ae405 100644
--- a/scripts/headers_install.pl
+++ b/scripts/headers_install.pl
@@ -36,6 +36,9 @@ foreach my $file (@files) {
 		$line =~ s/\s__attribute_const__\s/ /g;
 		$line =~ s/\s__attribute_const__$//g;
 		$line =~ s/^#include <linux\/compiler.h>//;
+		$line =~ s/(^|\s)(inline)\b/$1__$2__/g;
+		$line =~ s/(^|\s)(asm)\b(\s|[(]|$)/$1__$2__$3/g;
+		$line =~ s/(^|\s|[(])(volatile)\b(\s|[(]|$)/$1__$2__$3/g;
 		printf OUTFILE "%s", $line;
 	}
 	close OUTFILE;
-- 
1.6.0.2.GIT

