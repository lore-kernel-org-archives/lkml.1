Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbZG1PIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbZG1PIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZG1PI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:08:29 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:35270 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbZG1PG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=qi3m1JXuB0f8geqLF4CDrohxb7pE0BTBNEc9JeB3Zum30vpBj6RkiTYTJVuyU6OFDN
         +klr3SS4u6lHJwkhhE/sEFdAhnvI89VIwub71HZxYdxwzTOCzeBaZxJPYvvaHKwbFXSg
         X/51NP030W9QEvBUK6Af3RMCc0THqdx4kaBn8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Petr Vandrovec <vandrove@vc.cvut.cz>
Subject: [PATCH] ncpfs: fix wrong check in __ncp_ioctl()
Date: Tue, 28 Jul 2009 17:05:34 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090723-04314-g011b7b2-dirty; KDE/4.2.4; i686; ; )
Cc: Julia Lawall <julia@diku.dk>, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com,
       linware@sh.cvut.cz
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907281705.35211.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ncpfs: fix wrong check in __ncp_ioctl()

We want to check for s_inode's existence, not inode's one
(inode is always valid in this function).

This takes care of the following entry from Dan's list:

fs/ncpfs/ioctl.c +445 __ncp_ioctl(180) warning: variable derefenced before check 'inode'

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: corbet@lwn.net
Cc: eteo@redhat.com
Cc: Julia Lawall <julia@diku.dk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 fs/ncpfs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/fs/ncpfs/ioctl.c
===================================================================
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -442,7 +442,7 @@ static int __ncp_ioctl(struct inode *ino
 			if (dentry) {
 				struct inode* s_inode = dentry->d_inode;
 				
-				if (inode) {
+				if (s_inode) {
 					NCP_FINFO(s_inode)->volNumber = vnum;
 					NCP_FINFO(s_inode)->dirEntNum = de;
 					NCP_FINFO(s_inode)->DosDirNum = dosde;
