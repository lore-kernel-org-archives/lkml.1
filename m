Return-Path: <linux-kernel-owner+w=401wt.eu-S1759787AbXHWQjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787AbXHWQjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 12:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbXHWQjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 12:39:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:56989 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbXHWQjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 12:39:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Ss1Xlc5a2NzYocVsNIYAqcE7STqOxtQg70sDLLYwojmAMA5FVnGdfotNPfsfY3BKaWFM1xf+dIOOYmAZVmdjjcErqPCkB1DhmloS0wEhKT2erdzX0MRwrNxOZj+UXBnK3GlAXKnZnHQc4E8z4cBjHDg7vtWmd5CPHUu+H8Mh/Sg=
Date: Thu, 23 Aug 2007 20:39:17 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Steve French <sfrench@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] CIFS: fix unbalanced calls to Get/FreeXid
Message-ID: <20070823163917.GB7222@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes unbalanced calls to GetXid/FreeXid.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 fs/cifs/cifsfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index cabb6a5..2493cc4 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -346,7 +346,7 @@ int cifs_xquota_set(struct super_block *sb, int quota_type, qid_t qid,
 	if (pTcon) {
 		cFYI(1, ("set type: 0x%x id: %d", quota_type, qid));
 	} else {
-		return -EIO;
+		rc = -EIO;
 	}
 
 	FreeXid(xid);
