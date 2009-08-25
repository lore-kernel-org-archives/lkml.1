Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbZHYU7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbZHYU7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 16:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbZHYU7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 16:59:38 -0400
Received: from server1.wserver.cz ([82.113.45.157]:60644 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbZHYU7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 16:59:36 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: tiwai@suse.de
Cc: perex@perex.cz, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Isaku Yamahata <yamahata@private.email.ne.jp>,
       George Hansper <ghansper@apana.org.au>
Subject: [PATCH 2/4] SOUND: serial-u16550, use unitialized_var(uart)
Date: Tue, 25 Aug 2009 22:59:35 +0200
Message-Id: <1251233977-5819-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1251233977-5819-1-git-send-email-jirislaby@gmail.com>
References: <1251233977-5819-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid a wrong compiler warning, use unitialized_var(uart) in
snd_uart16550_rmidi.

If uart is unitialized, we return before its use.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Isaku Yamahata <yamahata@private.email.ne.jp>
Cc: George Hansper <ghansper@apana.org.au>
---
 sound/drivers/serial-u16550.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/drivers/serial-u16550.c b/sound/drivers/serial-u16550.c
index a25fb7b..5f8ae28 100644
--- a/sound/drivers/serial-u16550.c
+++ b/sound/drivers/serial-u16550.c
@@ -902,7 +902,7 @@ static int __devinit snd_uart16550_rmidi(struct snd_uart16550 *uart, int device,
 static int __devinit snd_serial_probe(struct platform_device *devptr)
 {
 	struct snd_card *card;
-	struct snd_uart16550 *uart;
+	struct snd_uart16550 *uninitialized_var(uart);
 	int err;
 	int dev = devptr->id;
 
-- 
1.6.3.3

