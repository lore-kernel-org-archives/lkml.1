Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbZISVrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbZISVrx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZISVnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:43:55 -0400
Received: from kroah.org ([198.145.64.141]:40543 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727AbZISVny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:43:54 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 63/79] tty: Power: fix suspend vt regression
Date: Sat, 19 Sep 2009 14:37:08 -0700
Message-Id: <1253396244-7885-63-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

vt_waitactive no longer accepts console parameter as console-1
since commit "vt: add an event interface". It expects console
number directly (as viewed by userspace -- counting from 1).

Fix a deadlock suspend regression by redefining adding one
to vt in vt_move_to_console.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/vt_ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 30b5d12..29c651a 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -1757,7 +1757,7 @@ int vt_move_to_console(unsigned int vt, int alloc)
 		return -EIO;
 	}
 	release_console_sem();
-	if (vt_waitactive(vt)) {
+	if (vt_waitactive(vt + 1)) {
 		pr_debug("Suspend: Can't switch VCs.");
 		return -EINTR;
 	}
-- 
1.6.4.2

