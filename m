Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbZLKEgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbZLKEgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761362AbZLKEg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:26 -0500
Received: from kroah.org ([198.145.64.141]:36733 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759506AbZLKEft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:49 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:38 2009
Message-Id: <20091211042737.946304901@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Akira Fujita <a-fujita@rs.jp.nec.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [19/90] ext4: Return exchanged blocks count to user space in failure
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0019-ext4-Return-exchanged-blocks-count-to-user-space-in-.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 8d6669133d8cdbb7cbe0e1f0f3744e7802a84afe)

Return exchanged blocks count (moved_len) to user space,
if ext4_move_extents() failed on the way.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ioctl.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -243,10 +243,9 @@ setversion_out:
 					me.donor_start, me.len, &me.moved_len);
 		fput(donor_filp);
 
-		if (!err)
-			if (copy_to_user((struct move_extent *)arg,
-				&me, sizeof(me)))
-				return -EFAULT;
+		if (copy_to_user((struct move_extent *)arg, &me, sizeof(me)))
+			return -EFAULT;
+
 		return err;
 	}
 


