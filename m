Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbYCJOhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbYCJOhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 10:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbYCJOg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 10:36:59 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:32779 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYCJOg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 10:36:58 -0400
X-Greylist: delayed 735 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Mar 2008 10:36:57 EDT
From: Jiri Slaby <jirislaby@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Dean Anderson <dean@sensoray.com>,
       linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] USB: s2255drv, fix memset(0)
Date: Mon, 10 Mar 2008 15:36:47 +0100
Message-Id: <1205159807-11701-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swap second and third paramter of memset in s2255_board_init, since it's
apparently wrong. Also do not re-init its entries to 0 again.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/usb/image/s2255drv.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/image/s2255drv.c b/drivers/usb/image/s2255drv.c
index e1cf2dc..2d15a36 100644
--- a/drivers/usb/image/s2255drv.c
+++ b/drivers/usb/image/s2255drv.c
@@ -2393,9 +2393,7 @@ static int s2255_board_init(struct s2255_dev *dev)
 	for (j = 0; j < MAX_PIPE_BUFFERS; j++) {
 		struct s2255_pipeinfo *pipe = &dev->pipes[j];
 
-		memset(pipe, sizeof(struct s2255_pipeinfo), 0);
-		pipe->state = 0;
-		pipe->prev_state = 0;
+		memset(pipe, 0, sizeof(*pipe));
 		pipe->dev = dev;
 		pipe->cur_transfer_size = DEFAULT_PIPE_USBBLOCK;
 		pipe->max_transfer_size = MAX_PIPE_USBBLOCK;
-- 
1.5.4.1

