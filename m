Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbZHKVUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbZHKVUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 17:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbZHKVUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 17:20:42 -0400
Received: from server1.wserver.cz ([82.113.45.157]:57312 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbZHKVUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 17:20:41 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@linux.intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 1/1] Power: fix suspend vt regression
Date: Tue, 11 Aug 2009 23:20:41 +0200
Message-Id: <1250025641-5763-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <4A81E073.5080703@gmail.com>
References: <4A81E073.5080703@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vt_waitactive no longer accepts console parameter as console-1
since commit "vt: add an event interface". It expects console
number directly (as viewed by userspace -- counting from 1).

Fix a deadlock suspend regression by redefining adding one
to vt in vt_move_to_console.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 drivers/char/vt_ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 0fceb8f..e3d4d13 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -1554,7 +1554,7 @@ int vt_move_to_console(unsigned int vt, int alloc)
 		return -EIO;
 	}
 	release_console_sem();
-	if (vt_waitactive(vt)) {
+	if (vt_waitactive(vt + 1)) {
 		pr_debug("Suspend: Can't switch VCs.");
 		return -EINTR;
 	}
-- 
1.6.3.3

