Return-Path: <linux-kernel-owner+w=401wt.eu-S932221Ab0AFBVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab0AFBVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 20:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370Ab0AFBU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 20:20:26 -0500
Received: from mail.perches.com ([173.55.12.10]:1535 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab0AFBUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 20:20:25 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 2/8] drivers/staging/pohmelfs/inode.c: Remove uses of NIPQUAD, use %pI4
Date: Tue,  5 Jan 2010 17:20:14 -0800
Message-Id: <18ee9e2cbf38c94a898505a8dc1c5ce412192fb4.1262726222.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1262726222.git.joe@perches.com>
References: <cover.1262726222.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/pohmelfs/inode.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index f69b778..e286fd1 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -1767,8 +1767,7 @@ static int pohmelfs_show_stats(struct seq_file *m, struct vfsmount *mnt)
 		seq_printf(m, "%u ", ctl->idx);
 		if (ctl->addr.sa_family == AF_INET) {
 			struct sockaddr_in *sin = (struct sockaddr_in *)&st->ctl.addr;
-			/* seq_printf(m, "%pi4:%u", &sin->sin_addr.s_addr, ntohs(sin->sin_port)); */
-			seq_printf(m, "%u.%u.%u.%u:%u", NIPQUAD(sin->sin_addr.s_addr), ntohs(sin->sin_port));
+			seq_printf(m, "%pI4:%u", &sin->sin_addr.s_addr, ntohs(sin->sin_port));
 		} else if (ctl->addr.sa_family == AF_INET6) {
 			struct sockaddr_in6 *sin = (struct sockaddr_in6 *)&st->ctl.addr;
 			seq_printf(m, "%pi6:%u", &sin->sin6_addr, ntohs(sin->sin6_port));
-- 
1.6.6.rc0.57.gad7a

