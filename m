Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZGJKeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZGJKeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbZGJKe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:34:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:51888 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbZGJKe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:34:29 -0400
Date: Fri, 10 Jul 2009 12:34:27 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, walt <w41ter@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] isofs: fix Joliet regression
Message-ID: <20090710103427.GG17524@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] isofs: fix Joliet regression

commit 5404ac8e4418ab3d254950ee4f9bcafc1da20b4a ("isofs: cleanup mount
option processing") missed conversion of joliet option flag resulting
in non-working Joliet support.

CC: walt <w41ter@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
  Linus, please apply. Thanks.

 fs/isofs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/fs/isofs/inode.c
===================================================================
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -142,6 +142,7 @@ static const struct dentry_operations is
 
 struct iso9660_options{
 	unsigned int rock:1;
+	unsigned int joliet:1;
 	unsigned int cruft:1;
 	unsigned int hide:1;
 	unsigned int showassoc:1;
@@ -151,7 +152,6 @@ struct iso9660_options{
 	unsigned int gid_set:1;
 	unsigned int utf8:1;
 	unsigned char map;
-	char joliet;
 	unsigned char check;
 	unsigned int blocksize;
 	mode_t fmode;
@@ -632,7 +632,7 @@ static int isofs_fill_super(struct super
 			else if (isonum_711(vdp->type) == ISO_VD_SUPPLEMENTARY) {
 				sec = (struct iso_supplementary_descriptor *)vdp;
 				if (sec->escape[0] == 0x25 && sec->escape[1] == 0x2f) {
-					if (opt.joliet == 'y') {
+					if (opt.joliet) {
 						if (sec->escape[2] == 0x40)
 							joliet_level = 1;
 						else if (sec->escape[2] == 0x43)
