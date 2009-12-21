Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbZLULt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbZLULt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 06:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbZLULt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 06:49:27 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:40518 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625AbZLULt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 06:49:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Q41v7D+grF6OMPTlLF5t3c7ZY0ynrcRWUK2X16Qan3DPvmwVZRsgWzikF+9m7dkzN2
         yKgmmvsW+Oa/V4sBHCbypG5ZGXsGbdxoxJFiBjrbg2Lg+Y7xSVn4Kc6TtC15a+lQfYxM
         AY2NNPLj7HjlPynkHmNDvDoKg0UPkuO2sTVvQ=
Message-ID: <4B2F619A.8000407@gmail.com>
Date: Mon, 21 Dec 2009 19:52:58 +0800
From: Liuwenyi <qingshenlwy@gmail.com>
Reply-To: qingshenlwy@gmail.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk, joel.becker@oracle.com,
       cjb@laptop.org, jmorris@namei.org, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, onlyflyer@gmail.com, strongzgy@gmail.com
Subject: [PATCHv2 02/12]posix_acl: Add the check items
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move the ACL validation check in to fs/posix_acl.c.
Including nullpointer check and PTR_ERR check.


---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: James Morris <jmorris@namei.org>
Cc: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 2e9e699..0f14f95 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -102,12 +102,9 @@ static int btrfs_set_acl(struct btrfs_trans_handle
*trans,
char *value = NULL;
mode_t mode;

- if (acl) {
- ret = posix_acl_valid(acl);
- if (ret < 0)
- return ret;
- ret = 0;
- }
+ ret = posix_acl_valid(acl);
+ if (ret < 0)
+ return ret;

switch (type) {
case ACL_TYPE_ACCESS:

-- 
Best Regards,
Liuwenyi

