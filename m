Return-Path: <linux-kernel-owner+w=401wt.eu-S932901AbXGaQrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbXGaQrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760630AbXGaQq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:46:57 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3395 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbXGaQq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:46:56 -0400
Date: Tue, 31 Jul 2007 12:46:08 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: akpm@linux-foundation.org, jeremy@goop.org, linux-kernel@vger.kernel.org
Cc: nhorman@tuxdriver.com
Subject: [PATCH] argv_split: allow argv_split to handle NULL pointer in argcp parameter gracefully
Message-ID: <20070731164608.GB28333@hmsreliant.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As Jeremy and I had discussed in a previous thread, it would be nice if the
argv_split library function could gracefully handle a NULL pointer in the argcp
parameter, so as to allow functions using it that did not care about the value
of argc to not have to declare a useless variable.  This patch accomplishes
that.  Tested by me, with successful results.

Thanks & Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 argv_split.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/lib/argv_split.c b/lib/argv_split.c
index 4096ed4..fad6ce4 100644
--- a/lib/argv_split.c
+++ b/lib/argv_split.c
@@ -75,7 +75,9 @@ char **argv_split(gfp_t gfp, const char *str, int *argcp)
 	if (argv == NULL)
 		goto out;
 
-	*argcp = argc;
+	if (argcp)
+		*argcp = argc;
+
 	argvp = argv;
 
 	while (*str) {
-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
