Return-Path: <linux-kernel-owner+w=401wt.eu-S935143AbZLGNy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935143AbZLGNy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935132AbZLGNy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:54:28 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:38225 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935094AbZLGNyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:54:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QiWqCqP6dWUrR3CifVHPy2V8LvfdyiEC83G1eLRs7kbNjQDX+8nJoDH1VHI3EtKAdh
         W/A/OOXDVMMV9lGYGbl3tRj7rX/qqPplIUctm8LXSFfXH83Ugjryx9bLPC2Kda7/DGvy
         kWMFWabsKkKxdTiaDpITnREvXDlemNM4+iBnA=
From: root <jeremy.cochoy@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, Manish Katiyar <mkatiyar@gmail.com>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Corentin Chary <corentin.chary@gmail.com>,
       Jeremy Cochoy <jeremy.cochoy@gmail.com>
Subject: [PATCH] fix ext2 parse_options printk
Date: Mon,  7 Dec 2009 15:01:01 +0100
Message-Id: <1260194461-8937-2-git-send-email-jeremy.cochoy@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1260194461-8937-1-git-send-email-jeremy.cochoy@gmail.com>
References: <1260194461-8937-1-git-send-email-jeremy.cochoy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Cochoy <jeremy.cochoy@gmail.com>

Signed-off-by: Jeremy Cochoy <jeremy.cochoy@gmail.com>
---
 fs/ext2/super.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 1a9ffee..f28618f 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -505,7 +505,7 @@ static int parse_options (char * options,
 #else
 		case Opt_user_xattr:
 		case Opt_nouser_xattr:
-			printk("EXT2 (no)user_xattr options not supported\n");
+			printk(KERN_NOTICE "EXT2 (no)user_xattr options not supported\n");
 			break;
 #endif
 #ifdef CONFIG_EXT2_FS_POSIX_ACL
@@ -518,14 +518,14 @@ static int parse_options (char * options,
 #else
 		case Opt_acl:
 		case Opt_noacl:
-			printk("EXT2 (no)acl options not supported\n");
+			printk(KERN_NOTICE "EXT2 (no)acl options not supported\n");
 			break;
 #endif
 		case Opt_xip:
 #ifdef CONFIG_EXT2_FS_XIP
 			set_opt (sbi->s_mount_opt, XIP);
 #else
-			printk("EXT2 xip option not supported\n");
+			printk(KERN_NOTICE "EXT2 xip option not supported\n");
 #endif
 			break;
 
@@ -550,11 +550,11 @@ static int parse_options (char * options,
 
 		case Opt_reservation:
 			set_opt(sbi->s_mount_opt, RESERVATION);
-			printk("reservations ON\n");
+			printk(KERN_INFO "reservations ON\n");
 			break;
 		case Opt_noreservation:
 			clear_opt(sbi->s_mount_opt, RESERVATION);
-			printk("reservations OFF\n");
+			printk(KERN_INFO "reservations OFF\n");
 			break;
 		case Opt_ignore:
 			break;
-- 
1.5.6.5

