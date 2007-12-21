Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbXLUQC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbXLUQC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbXLUQCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:02:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:41763 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbXLUQCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:02:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=rBDkcLWiFPf/r3U3Gk3ar/yH/1At7ETBsvicsAS9/2cYtmyZj26mZGqaI6X2woiCAoAkHvaVKRIRvWhD4U/N39Di22LuGE5QkIT/CGyY6xWILePSJ5zMGMosLljPhNiCURBQebDZlZlcp/5qnFIc45hiRYGDT5KO5XxTpCkHrkU=
Date: Fri, 21 Dec 2007 17:04:31 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5/5] udf: fix signedness issue
Message-ID: <20071221160427.GE8575@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse generated:
fs/udf/namei.c:896:15: originally declared here
fs/udf/namei.c:1147:41: warning: incorrect type in argument 3 (different signedness)
fs/udf/namei.c:1147:41:    expected int *offset
fs/udf/namei.c:1147:41:    got unsigned int *<noident>
fs/udf/namei.c:1152:78: warning: incorrect type in argument 3 (different signedness)
fs/udf/namei.c:1152:78:    expected int *offset
fs/udf/namei.c:1152:78:    got unsigned int *<noident>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/udf/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index bec96a6..066153f 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1131,7 +1131,7 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 	}
 	if (S_ISDIR(old_inode->i_mode)) {
-		uint32_t offset = udf_ext0_offset(old_inode);
+		int offset = udf_ext0_offset(old_inode);

 		if (new_inode) {
 			retval = -ENOTEMPTY;
--
1.5.3.4

