Return-Path: <linux-kernel-owner+w=401wt.eu-S1759901AbXGIQ3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901AbXGIQ3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758028AbXGIQXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757984AbXGIQXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:44 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Fabio Massimo Di Nitto <fabbione@ubuntu.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] latest gfs2-nmw headers break userland build
Date: Mon,  9 Jul 2007 17:02:24 +0100
Message-Id: <1183997026104-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970241526-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Massimo Di Nitto <fabbione@ubuntu.com>

2e8701a15cd6f7c95e74d6660615a69b09e453ef commit breaks libgfs2 build:

gcc -Wall -I/usr/src/ubuntu/mypkgs/rhcluster/cluster/config -DHELPER_PROGRAM
-D_FILE_OFFSET_BITS=64 -DGFS2_RELEASE_NAME=\"2.0\" -ggdb  -I/usr/include
-I../include -I../libgfs2 -c -o gfs2hex.o gfs2hex.c
In file included from hexedit.h:22,
                  from gfs2hex.c:27:
/usr/include/linux/gfs2_ondisk.h:505: error: expected specifier-qualifier-list
before ‘u32’
make[2]: *** [gfs2hex.o] Error 1
make[2]: Leaving directory `/usr/src/ubuntu/mypkgs/rhcluster/cluster/gfs2/edit'
make[1]: *** [all] Error 2
make[1]: Leaving directory `/usr/src/ubuntu/mypkgs/rhcluster/cluster/gfs2'
make: *** [gfs2] Error 2

Signed-off-by: Fabio Massimo Di Nitto <fabbione@ubuntu.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/include/linux/gfs2_ondisk.h b/include/linux/gfs2_ondisk.h
index 028f981..9ecf929 100644
--- a/include/linux/gfs2_ondisk.h
+++ b/include/linux/gfs2_ondisk.h
@@ -502,7 +502,7 @@ struct gfs2_quota_change_host {
 
 struct gfs2_quota_lvb {
         __be32 qb_magic;
-        u32 __pad;
+        __u32 __pad;
         __be64 qb_limit;      /* Hard limit of # blocks to alloc */
         __be64 qb_warn;       /* Warn user when alloc is above this # */
         __be64 qb_value;       /* Current # blocks allocated */
-- 
1.5.1.2

