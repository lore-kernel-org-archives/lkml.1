Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbXFCUr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbXFCUr2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbXFCUq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:46:26 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52959 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbXFCUqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:46:24 -0400
Date: Sun, 3 Jun 2007 22:47:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: [PATCH 10/19] kbuild: add support for reading stdin with gen_init_cpio
Message-ID: <20070603204725.GJ9240@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 10/19] kbuild: add support for reading stdin with gen_init_cpio
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 10 May 2007 22:44:28 -0700

Treat an argument of "-" as meaning "read stdin for cpio files" so
gen_init_cpio can be piped into.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 usr/gen_init_cpio.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index 8365db6..7abc07f 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -498,7 +498,9 @@ int main (int argc, char *argv[])
 		exit(1);
 	}
 
-	if (! (cpio_list = fopen(argv[1], "r"))) {
+	if (!strcmp(argv[1], "-"))
+		cpio_list = stdin;
+	else if (! (cpio_list = fopen(argv[1], "r"))) {
 		fprintf(stderr, "ERROR: unable to open '%s': %s\n\n",
 			argv[1], strerror(errno));
 		usage(argv[0]);
-- 
1.5.1.rc3.1544.g8a923


----- End forwarded message -----
