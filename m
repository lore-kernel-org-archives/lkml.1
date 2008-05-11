Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbYEKUAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbYEKUAf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbYEKUA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:00:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:43605 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbYEKUA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:00:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=alF3YeFs+N/em4pZ8O8kmsQF/BSoZOdHkX26y/zH5dBSYsDupFoDBOfbWIzMXCZ+dwrTWMLP6uro0L6MxGNPr71BKpkZ7Egc9nTpQF3UGWK1mBkfAiqdY37ou1KLKS3t1ACoTT7Io4luJ0Ier/2ZuYxIDZVcLAI+q3w33Upo8TY=
Date: Sun, 11 May 2008 22:00:02 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steve French <sfrench@us.ibm.com>
Subject: [PATCH] cifs: CIFSSMBPosixLock should return -EINVAL on error
Message-ID: <20080511195959.GH19058@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all other codepaths in this function return negative values on errors

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Steve French <sfrench@us.ibm.com>
---
compile tested only
---
 fs/cifs/cifssmb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1771,7 +1771,7 @@ CIFSSMBPosixLock(const int xid, struct cifsTconInfo *tcon,
 	cFYI(1, ("Posix Lock"));
 
 	if (pLockData == NULL)
-		return EINVAL;
+		return -EINVAL;
 
 	rc = small_smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB);
 
-- 
