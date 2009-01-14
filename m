Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbZANAH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbZANAH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760397AbZANAHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:07:45 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:8721 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760148AbZANAHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:07:43 -0500
X-IronPort-AV: E=Sophos;i="4.37,261,1231113600"; 
   d="scan'208";a="27989234"
From: Roland Dreier <rdreier@cisco.com>
To: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: Remove extra KERN_INFO in the middle of a line
X-Message-Flag: Warning: May contain useful information
Date: Tue, 13 Jan 2009 16:07:41 -0800
Message-ID: <adamydukawi.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Jan 2009 00:07:41.0885 (UTC) FILETIME=[1E540ED0:01C975DC]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "devid <xxx> transid <xxx>" printk in btrfs_scan_one_device()
actually follows another printk that doesn't end in a newline (since the
intention is for the two printks to make one line of output), so the
KERN_INFO just ends up messing up the output:

    device label exp <6>devid 1 transid 9 /dev/sda5

Fix this by deleting the extra KERN_INFO.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 fs/btrfs/volumes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b187b53..2280d19 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -577,7 +577,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 		       *(unsigned long long *)disk_super->fsid,
 		       *(unsigned long long *)(disk_super->fsid + 8));
 	}
-	printk(KERN_INFO "devid %llu transid %llu %s\n",
+	printk("devid %llu transid %llu %s\n",
 	       (unsigned long long)devid, (unsigned long long)transid, path);
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
 
