Return-Path: <linux-kernel-owner+w=401wt.eu-S1764719AbXLPCO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764719AbXLPCO1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 21:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757408AbXLPCOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 21:14:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:44359 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148AbXLPCOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 21:14:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=oAeggPJWe4a6hzTxGKVEpsQI9GohZG6n+kRMf+unxAfkZEFSD2bKWNQAXwjKoZvNizdFlQY8Kz3sFcfvbIX/zsRfcORu/fwbSOOoYvVRkXetwJ5A3O6140jX9gAyCPeeD4jFughrVOKGQJ85v2eqazRQW02X+0hDA8Azh789N68=
Date: Sun, 16 Dec 2007 03:15:59 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: [PATCH 5/6] udf: fix signedness issue
Message-ID: <20071216021556.GF26986@joi>
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

