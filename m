Return-Path: <linux-kernel-owner+w=401wt.eu-S1759364AbZBMMyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364AbZBMMyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZBMMyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:54:10 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:33000 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbZBMMyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:54:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xp3mPSdwfcZ60I7OsVe56fkULPPq2Ftr2TckEBu6NktRk84rtdSMBUE1migFpufhVw
         FWOIsK4aQroo0tFU1uXXDe/obpjaG6OVwygwBRgNrPYO23sfsWHWU+tHitRBoHPjg9nG
         dgn7tRgyQ9FL6MItAxFp2eyyGTPOrdC6o+b8w=
Date: Fri, 13 Feb 2009 15:53:57 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: zbr@ioremap.net, gregkh@suse.de, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH next 1/2] pohmelfs: fix build breakage
Message-ID: <20090213125357.GA7003@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/pohmelfs/inode.c:982: error: implicit declaration of
function 'DQUOT_TRANSFER'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/pohmelfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index 0980c3c..908fc64 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -979,7 +979,7 @@ int pohmelfs_setattr_raw(struct inode *inode, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
 	    (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid)) {
-		err = DQUOT_TRANSFER(inode, attr) ? -EDQUOT : 0;
+		err = vfs_dq_transfer(inode, attr) ? -EDQUOT : 0;
 		if (err)
 			goto err_out_exit;
 	}
