Return-Path: <linux-kernel-owner+w=401wt.eu-S1762626AbXERG6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626AbXERG6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbXERG6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:58:32 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:58989 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346AbXERG6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:58:31 -0400
Date: Fri, 18 May 2007 08:59:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 11/14] kbuild: add support for reading stdin with gen_init_cpio
Message-ID: <20070518065929.GK12284@uranus.ravnborg.org>
References: <20070518064126.GA12193@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518064126.GA12193@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From ad5409f51b70b12575a8b0dc07c897395311d13b Mon Sep 17 00:00:00 2001
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 10 May 2007 22:44:28 -0700
Subject: [PATCH 11/14] kbuild: add support for reading stdin with gen_init_cpio

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
1.5.1.rc3.20.gaa453

