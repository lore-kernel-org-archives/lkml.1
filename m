Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbZASNhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbZASNhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbZASNgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:36:53 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:15206 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbZASNgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:36:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=iJ93wkSKkQK4/RBRTsW8ZNniTgwrHu2pFiqO42S+cGPp2RwScrBXLTMYCpD4eQlY91
         NBsw+BcLCU0JflghMHio60fRENqE7XNp4XD2mzyXD2tuBYJMDNoVMaIZMoBfPoWIoIna
         0b+D8cdcVVZceLr3JGDhck7kuGvOzbwnvDcG8=
Date: Mon, 19 Jan 2009 21:36:31 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [Patch] btrfs: cleanup fs/btrfs/super.c::btrfs_control_ioctl()
Message-ID: <20090119133631.GA7863@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Remove the unused local variable 'len';
- Check return value of kmalloc().

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Chris Mason <chris.mason@oracle.com>

---
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index db9fb3b..0e9d259 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -583,17 +583,18 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 	struct btrfs_ioctl_vol_args *vol;
 	struct btrfs_fs_devices *fs_devices;
 	int ret = -ENOTTY;
-	int len;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	vol = kmalloc(sizeof(*vol), GFP_KERNEL);
+	if (!vol)
+		return -ENOMEM;
+
 	if (copy_from_user(vol, (void __user *)arg, sizeof(*vol))) {
 		ret = -EFAULT;
 		goto out;
 	}
-	len = strnlen(vol->name, BTRFS_PATH_NAME_MAX);
 
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:

