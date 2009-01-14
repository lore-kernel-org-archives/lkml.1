Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbZANSev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbZANSev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbZANSej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:34:39 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:34408 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbZANSeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:34:37 -0500
X-IronPort-AV: E=Sophos;i="4.37,263,1231113600"; 
   d="scan'208";a="229837703"
From: Roland Dreier <rdreier@cisco.com>
To: "Chris Mason" <chris.mason@oracle.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove extra KERN_INFO in the middle of a line
References: <adamydukawi.fsf@cisco.com>
	<84144f020901132357h7fbac614yb95557d2fcc7c316@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 14 Jan 2009 10:34:35 -0800
In-Reply-To: <84144f020901132357h7fbac614yb95557d2fcc7c316@mail.gmail.com>
	(Pekka Enberg's message of "Wed, 14 Jan 2009 09:57:26 +0200")
Message-ID: <adaeiz5ivno.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Jan 2009 18:34:35.0903 (UTC) FILETIME=[C02AF8F0:01C97676]
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

Fix this by changing the extra KERN_INFO to KERN_CONT.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 > We have KERN_CONT for this.

OK, updated patch below...

 fs/btrfs/volumes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b187b53..bc7e113 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -577,7 +577,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 		       *(unsigned long long *)disk_super->fsid,
 		       *(unsigned long long *)(disk_super->fsid + 8));
 	}
-	printk(KERN_INFO "devid %llu transid %llu %s\n",
+	printk(KERN_CONT "devid %llu transid %llu %s\n",
 	       (unsigned long long)devid, (unsigned long long)transid, path);
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
 
