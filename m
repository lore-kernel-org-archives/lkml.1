Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab0BNUhH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 15:37:07 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:54739 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab0BNUhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 15:37:04 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       devel@driverdev.osuosl.org, Phil Hannent <phil@hannent.co.uk>,
       <mwilder@cs.nmsu.edu>, Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH] staging: mimio, add extra sync to down-up input events
Date: Sun, 14 Feb 2010 21:37:01 +0100
Message-Id: <1266179821-900-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace is allowed to coalesce events between SYNCs. And since the code
emits UP right after DOWN for the same key, it may be missed
(up+down=nothing). Add an extra sync in between UP and DOWN events to disable
the coalesce.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org
Cc: Phil Hannent <phil@hannent.co.uk>
Cc: <mwilder@cs.nmsu.edu>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/staging/mimio/mimio.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/mimio/mimio.c b/drivers/staging/mimio/mimio.c
index 2cfef4a..08a5400 100644
--- a/drivers/staging/mimio/mimio.c
+++ b/drivers/staging/mimio/mimio.c
@@ -730,6 +730,7 @@ static void mimio_rx_handler(struct mimio *mimio,
 			dev_dbg(dev, "mem-reset.\n");
 			/* input_regs(mimio->idev, regs); */
 			input_event(mimio->idev, EV_KEY, BTN_0, 1);
+			input_sync(mimio->idev);
 			input_event(mimio->idev, EV_KEY, BTN_0, 0);
 			input_sync(mimio->idev);
 			mimio->pktbuf.p += 7;
@@ -750,6 +751,7 @@ static void mimio_rx_handler(struct mimio *mimio,
 				dev_dbg(&mimio->idev->dev, "new-page.\n");
 				/* input_regs(mimio->idev, regs); */
 				input_event(mimio->idev, EV_KEY, BTN_1, 1);
+				input_sync(mimio->idev);
 				input_event(mimio->idev, EV_KEY, BTN_1, 0);
 				input_sync(mimio->idev);
 				break;
@@ -757,6 +759,7 @@ static void mimio_rx_handler(struct mimio *mimio,
 				dev_dbg(&mimio->idev->dev, "tag-page.\n");
 				/* input_regs(mimio->idev, regs); */
 				input_event(mimio->idev, EV_KEY, BTN_2, 1);
+				input_sync(mimio->idev);
 				input_event(mimio->idev, EV_KEY, BTN_2, 0);
 				input_sync(mimio->idev);
 				break;
@@ -764,6 +767,7 @@ static void mimio_rx_handler(struct mimio *mimio,
 				dev_dbg(&mimio->idev->dev, "print-page.\n");
 				/* input_regs(mimio->idev, regs);*/
 				input_event(mimio->idev, EV_KEY, BTN_3, 1);
+				input_sync(mimio->idev);
 				input_event(mimio->idev, EV_KEY, BTN_3, 0);
 				input_sync(mimio->idev);
 				break;
@@ -772,6 +776,7 @@ static void mimio_rx_handler(struct mimio *mimio,
 					"maximize-window.\n");
 				/* input_regs(mimio->idev, regs); */
 				input_event(mimio->idev, EV_KEY, BTN_4, 1);
+				input_sync(mimio->idev);
 				input_event(mimio->idev, EV_KEY, BTN_4, 0);
 				input_sync(mimio->idev);
 				break;
@@ -779,6 +784,7 @@ static void mimio_rx_handler(struct mimio *mimio,
 				dev_dbg(&mimio->idev->dev, "find-ctl-panel.\n");
 				/* input_regs(mimio->idev, regs); */
 				input_event(mimio->idev, EV_KEY, BTN_5, 1);
+				input_sync(mimio->idev);
 				input_event(mimio->idev, EV_KEY, BTN_5, 0);
 				input_sync(mimio->idev);
 				break;
-- 
1.6.6.1

