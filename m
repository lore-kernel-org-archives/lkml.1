Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbXEFHmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbXEFHmi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 03:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbXEFHmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 03:42:38 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49722 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718AbXEFHmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 03:42:37 -0400
Date: Sun, 6 May 2007 09:43:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Garski <mgarski@post.pl>
Subject: kconfig: fix mconf segmentation fault
Message-ID: <20070506074331.GD6492@uranus.ravnborg.org>
References: <20070502201741.GD9044@uranus.ravnborg.org> <20070506073615.GA6492@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070506073615.GA6492@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have found small bug in mconf, when you run it without any argument it
will sigsegv.

Without patch:
$ scripts/kconfig/mconf
Segmentation fault

With patch:
$ scripts/kconfig/mconf
can't find file (null)

Signed-off-by: Marcin Garski <mgarski@post.pl>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/lex.zconf.c_shipped |    2 +-
 scripts/kconfig/zconf.l             |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/lex.zconf.c_shipped b/scripts/kconfig/lex.zconf.c_shipped
index 800f8c7..0fdc904 100644
--- a/scripts/kconfig/lex.zconf.c_shipped
+++ b/scripts/kconfig/lex.zconf.c_shipped
@@ -2264,7 +2264,7 @@ FILE *zconf_fopen(const char *name)
 	FILE *f;
 
 	f = fopen(name, "r");
-	if (!f && name[0] != '/') {
+	if (!f && name != NULL && name[0] != '/') {
 		env = getenv(SRCTREE);
 		if (env) {
 			sprintf(fullname, "%s/%s", env, name);
diff --git a/scripts/kconfig/zconf.l b/scripts/kconfig/zconf.l
index cfa4607..187d38c 100644
--- a/scripts/kconfig/zconf.l
+++ b/scripts/kconfig/zconf.l
@@ -265,7 +265,7 @@ FILE *zconf_fopen(const char *name)
 	FILE *f;
 
 	f = fopen(name, "r");
-	if (!f && name[0] != '/') {
+	if (!f && name != NULL && name[0] != '/') {
 		env = getenv(SRCTREE);
 		if (env) {
 			sprintf(fullname, "%s/%s", env, name);
-- 
1.5.1.rc3.20.gaa453

