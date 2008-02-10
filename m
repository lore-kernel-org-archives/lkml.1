Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbYBJT2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbYBJT2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbYBJT2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:28:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:2164 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbYBJT2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:28:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=nx0G2aTMsmNkjqplWRFWsU+7KxNhyNeEkfoJyuewHIUEhjeztKXOkiOlTvjtoPLNpgDHxFBNQ0bz0XbwL47Cth1DhhxYq35yfDu9DP1Ab1nPVX9G2IK2EUDPuEMYzULGX1FdcAKzLOWJBTzss8kLxRgpiRBFLoNdWdxEm//AHKM=
Date: Sun, 10 Feb 2008 20:27:33 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>
Subject: [PATCH] udf: fix udf_add_free_space
Message-ID: <20080210192721.GA9979@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in commit 742ba02a51c8d0bf5446b154531179760c1ed0a2
(udf: create common function for changing free space counter)
by accident I reversed safety condition which lead to
null pointer dereference in case of media error
and wrong counting of free space in normal situation

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/balloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index a95fcfe..1b809bd 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -145,7 +145,7 @@ static bool udf_add_free_space(struct udf_sb_info *sbi,
 {
 	struct logicalVolIntegrityDesc *lvid;
 
-	if (sbi->s_lvid_bh)
+	if (sbi->s_lvid_bh == NULL)
 		return false;
 
 	lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
-- 
1.5.3.7

