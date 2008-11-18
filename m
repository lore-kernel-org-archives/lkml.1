Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbYKRP7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbYKRP7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYKRP7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:59:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:2236 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYKRP7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:59:06 -0500
Message-ID: <154e089b0811180759x4db4ba61k467fa2275710938f@mail.gmail.com>
Date: Tue, 18 Nov 2008 16:59:03 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "Jaroslav Kysela" <perex@perex.cz>, "Takashi Iwai" <tiwai@suse.de>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound: Fix warnings relating to ignored return value in snd_card_register
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not ignore the return of 'device_create_file' in
'snd_card_register' and thereby fixing the following warnings:

sound/core/init.c: In function 'snd_card_register':
sound/core/init.c:640: warning: ignoring return value of
'device_create_file', declared with attribute warn_unused_result
sound/core/init.c:641: warning: ignoring return value of
'device_create_file', declared with attribute warn_unused_result

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 sound/core/init.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index af1e407..814d834 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -637,8 +637,10 @@ int snd_card_register(struct snd_card *card)
 #endif
 #ifndef CONFIG_SYSFS_DEPRECATED
 	if (card->card_dev) {
-		device_create_file(card->card_dev, &card_id_attrs);
-		device_create_file(card->card_dev, &card_number_attrs);
+		if ((err = device_create_file(card->card_dev, &card_id_attrs)) < 0)
+			return err;
+		if ((err = device_create_file(card->card_dev, &card_number_attrs)) < 0)
+			return err;
 	}
 #endif
 	return 0;
