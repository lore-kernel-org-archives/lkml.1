Return-Path: <linux-kernel-owner+w=401wt.eu-S1763567AbXHFUJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763567AbXHFUJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756251AbXHFUJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:09:20 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1761 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbXHFUJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:09:19 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] drivers/media/video/arv.c: fix memset in ioctl
Date: Mon, 6 Aug 2007 22:09:17 +0200
User-Agent: KMail/1.9.5
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708062209.17830.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	Looks like memset() is zeroing wrong nr of bytes.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/media/video/arv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc1-mm2-a/drivers/media/video/arv.c	2007-08-01 08:43:47.000000000 +0200
+++ linux-2.6.23-rc1-mm2-b/drivers/media/video/arv.c	2007-08-06 20:36:00.000000000 +0200
@@ -441,7 +441,7 @@ static int ar_do_ioctl(struct inode *ino
 	{
 		struct video_window *w = arg;
 		DEBUG(1, "VIDIOCGWIN:\n");
-		memset(w, 0, sizeof(w));
+		memset(w, 0, sizeof(*w));
 		w->width = ar->width;
 		w->height = ar->height;
 		return 0;
