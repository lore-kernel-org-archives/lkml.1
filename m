Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZFDICU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZFDICU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZFDIB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:01:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60890 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZFDIB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:01:59 -0400
Date: Thu, 4 Jun 2009 04:01:52 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, sam@ravnborg.org,
       Amerigo Wang <amwang@redhat.com>, linux-kbuild@vger.kernel.org
Message-Id: <20090604080406.7005.27662.sendpatchset@localhost.localdomain>
Subject: [Patch 1/2] kbuild: two trivial fixes for check headers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove a useless 'extern' in an exported header.
Fix a comment headers_check.pl.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>

------
diff --git a/include/mtd/jffs2-user.h b/include/mtd/jffs2-user.h
index fa94b0e..10dc7ef 100644
--- a/include/mtd/jffs2-user.h
+++ b/include/mtd/jffs2-user.h
@@ -18,7 +18,7 @@
 #undef je32_to_cpu
 #undef jemode_to_cpu
 
-extern int target_endian;
+int target_endian;
 
 #define t16(x) ({ __u16 __b = (x); (target_endian==__BYTE_ORDER)?__b:bswap_16(__b); })
 #define t32(x) ({ __u32 __b = (x); (target_endian==__BYTE_ORDER)?__b:bswap_32(__b); })
diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 56f90a4..ccdbace 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -2,7 +2,7 @@
 #
 # headers_check.pl execute a number of trivial consistency checks
 #
-# Usage: headers_check.pl dir [files...]
+# Usage: headers_check.pl dir arch [files...]
 # dir:   dir to look for included files
 # arch:  architecture
 # files: list of files to check
