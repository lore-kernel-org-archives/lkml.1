Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZFEXrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZFEXrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbZFEXlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:50 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:45067 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbZFEXlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:13 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 34/39] scripts/headers_check.pl: correct RE in header CONFIG leak check
Date: Sat,  6 Jun 2009 01:42:52 +0200
Message-Id: <1244245377-17441-34-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@crashcourse.ca>

Correct the regular expression in scripts/headers_check.pl to include '_'
as a valid character in the class; otherwise, the check will report a
"leaked" symbol of CONFIG_A_B_C as merely CONFIG_A.

This patch will make no difference whatsoever in the current kernel tree
as the call to the perl routine that does that check is currently
commented out:

                &check_include();
                &check_asm_types();
                &check_sizetypes();
                &check_prototypes();
                # Dropped for now. Too much noise &check_config();

However, I noticed that problem when I was building the yum downloadable
kernel source rpm for fedora 11 (beta), which *does* run that check, and
that's where the problem became obvious.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/headers_check.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 3923888..e3fb949 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -74,7 +74,7 @@ sub check_declarations
 
 sub check_config
 {
-	if ($line =~ m/[^a-zA-Z0-9_]+CONFIG_([a-zA-Z0-9]+)[^a-zA-Z0-9]/) {
+	if ($line =~ m/[^a-zA-Z0-9_]+CONFIG_([a-zA-Z0-9_]+)[^a-zA-Z0-9_]/) {
 		printf STDERR "$filename:$lineno: leaks CONFIG_$1 to userspace where it is not valid\n";
 	}
 }
-- 
1.6.3.rc3.40.g75b44

