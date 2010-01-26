Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203Ab0AZArN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab0AZArN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319Ab0AZArM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:47:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62819 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab0AZArM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:47:12 -0500
Message-ID: <4B5E3BD7.9000001@cn.fujitsu.com>
Date: Tue, 26 Jan 2010 08:48:23 +0800
From: Yang Hongyang <yanghy@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH]btrfs:fix a memory leak in acl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In btrfs_init_acl(),cloned acl is not released.Fix that.

Signed-off-by: Yang Hongyang <yanghy@cn.fujitsu.com>

---
 fs/btrfs/acl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 54f4798..6df6d6e 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -244,6 +244,7 @@ int btrfs_init_acl(struct btrfs_trans_handle *trans,
 						    ACL_TYPE_ACCESS);
 			}
 		}
+		posix_acl_release(clone);
 	}
 failed:
 	posix_acl_release(acl);
-- 
1.6.5.2

-- 
Regards
Yang Hongyang
