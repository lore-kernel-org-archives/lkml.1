Return-Path: <linux-kernel-owner+w=401wt.eu-S1762077AbZLKEgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762077AbZLKEgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761371AbZLKEgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:25 -0500
Received: from kroah.org ([198.145.64.141]:36729 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759502AbZLKEfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:48 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:37 2009
Message-Id: <20091211042737.028935695@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Akira Fujita <a-fujita@rs.jp.nec.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [18/90] ext4: Remove unneeded BUG_ON() in ext4_move_extents()
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0018-ext4-Remove-unneeded-BUG_ON-in-ext4_move_extents.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit daea696dbac0e33af3cfe304efbfb8d74e0effe6)

The ext4_move_extents() functions checks with BUG_ON() whether the
exchanged blocks count accords with request blocks count.  But, if the
target range (orig_start + len) includes sparse block(s), 'moved_len'
(exchanged blocks count) does not agree with 'len' (request blocks
count), since sparse block is not counted in 'moved_len'.  This causes
us to hit the BUG_ON(), even though the function succeeded.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/move_extent.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -1322,8 +1322,5 @@ out2:
 	if (ret)
 		return ret;
 
-	/* All of the specified blocks must be exchanged in succeed */
-	BUG_ON(*moved_len != len);
-
 	return 0;
 }


