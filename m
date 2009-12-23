Return-Path: <linux-kernel-owner+w=401wt.eu-S1757041AbZLWTzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbZLWTzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbZLWTxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:53:17 -0500
Received: from kroah.org ([198.145.64.141]:52938 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbZLWTxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:53:09 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/10] vfs: get_sb_single() - do not pass options twice
Date: Wed, 23 Dec 2009 11:52:35 -0800
Message-Id: <1261597963-18323-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.6
In-Reply-To: <20091223194955.GB18101@kroah.com>
References: <20091223194955.GB18101@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Filesystem code usually destroys the option buffer while
parsing it. This leads to errors when the same buffer is
passed twice. In case we fill a new superblock do not call
remount.

This is needed to quite a warning that the debugfs code
causes every boot.

Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 19eb70b..aff046b 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -901,8 +901,9 @@ int get_sb_single(struct file_system_type *fs_type,
 			return error;
 		}
 		s->s_flags |= MS_ACTIVE;
+	} else {
+		do_remount_sb(s, flags, data, 0);
 	}
-	do_remount_sb(s, flags, data, 0);
 	simple_set_mnt(mnt, s);
 	return 0;
 }
-- 
1.6.5.7

