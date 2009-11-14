Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbZKNAKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbZKNAKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbZKNAKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:10:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:43139 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757420AbZKNAKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:10:21 -0500
Date: Sat, 14 Nov 2009 00:10:15 GMT
From: tip-bot for Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1258142222-16092-3-git-send-email-mjg@redhat.com>
References: <1258142222-16092-3-git-send-email-mjg@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/setup] vgacon: Add support for setting the default cursor state
Message-ID: <tip-b434a680a29424856e0f40199daa9f65963c7cb4@git.kernel.org>
Git-Commit-ID: b434a680a29424856e0f40199daa9f65963c7cb4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b434a680a29424856e0f40199daa9f65963c7cb4
Gitweb:     http://git.kernel.org/tip/b434a680a29424856e0f40199daa9f65963c7cb4
Author:     Matthew Garrett <mjg@redhat.com>
AuthorDate: Fri, 13 Nov 2009 14:57:02 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 13 Nov 2009 15:55:02 -0800

vgacon: Add support for setting the default cursor state

Pass the vga cursor state to the vt layer, ensuring that we don't hide
the cursor when the bootloader has deliberately disabled it.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
LKML-Reference: <1258142222-16092-3-git-send-email-mjg@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 drivers/video/console/vgacon.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 564643e..cc4bbbe 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -586,7 +586,10 @@ static void vgacon_init(struct vc_data *c, int init)
 	if (!vgacon_uni_pagedir[0] && p)
 		con_set_default_unimap(c);
 
-	hide_boot_cursor(screen_info.flags & VIDEO_FLAGS_NOCURSOR);
+	/* Only set the default if the user didn't deliberately override it */
+	if (global_cursor_default == -1)
+		global_cursor_default =
+			!(screen_info.flags & VIDEO_FLAGS_NOCURSOR);
 }
 
 static void vgacon_deinit(struct vc_data *c)
