Return-Path: <linux-kernel-owner+w=401wt.eu-S933454AbXEEVFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454AbXEEVFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 17:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933541AbXEEVFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 17:05:20 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:34749 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933454AbXEEVFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 17:05:19 -0400
Date: Sat, 5 May 2007 22:05:11 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix nfsroot build
Message-ID: <20070505210511.GA11342@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      fs/nfs/nfsroot.o
fs/nfs/nfsroot.c:131: error: tokens causes a section type conflict
make[2]: *** [fs/nfs/nfsroot.o] Error 1

This is due to mixing const and non-const content in the same section
which halfway recent gccs absolutely hate.  Fixed by dropping the const.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/include/linux/parser.h b/include/linux/parser.h
index 86676f6..26b2bdf 100644
--- a/include/linux/parser.h
+++ b/include/linux/parser.h
@@ -14,7 +14,7 @@ struct match_token {
 	const char *pattern;
 };
 
-typedef const struct match_token match_table_t[];
+typedef struct match_token match_table_t[];
 
 /* Maximum number of arguments that match_token will find in a pattern */
 enum {MAX_OPT_ARGS = 3};
