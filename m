Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbXLHUpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbXLHUpx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbXLHUpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:45:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:41374 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbXLHUpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:45:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=YlmnurPnGQXcDwEWm7njfp52/M1XT4wrV06BRi8qAMUCMKucO4QF4dOBeuBuPVM4LE3nkJgIGO5BqQfyaZl85fIpUJy0R1qoGYIUhN7BnTPMykF8wU4OzM0FDNZi3PXk5tdgYv6iMsQ2m1kfvMfQAZ7VsK52VXrWPkEG7EZiMSc=
Date: Sat, 8 Dec 2007 21:46:48 +0100
From: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
To: perex@perex.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] info_oss: move prototype of snd_card_info_read_oss to
	info.h
Message-ID: <20071208204644.GF5087@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

info_oss: move prototype of snd_card_info_read_oss to info.h

Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>
---
 include/sound/info.h  |    2 ++
 sound/core/info_oss.c |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/sound/info.h b/include/sound/info.h
index fecbb1f..8ae72e7 100644
--- a/include/sound/info.h
+++ b/include/sound/info.h
@@ -100,8 +100,10 @@ int snd_info_minor_unregister(void);
 extern struct snd_info_entry *snd_seq_root;
 #ifdef CONFIG_SND_OSSEMUL
 extern struct snd_info_entry *snd_oss_root;
+void snd_card_info_read_oss(struct snd_info_buffer *buffer);
 #else
 #define snd_oss_root NULL
+static inline void snd_card_info_read_oss(struct snd_info_buffer *buffer) {}
 #endif

 int snd_iprintf(struct snd_info_buffer * buffer, char *fmt,...) __attribute__ ((format (printf, 2, 3)));
diff --git a/sound/core/info_oss.c b/sound/core/info_oss.c
index 435c939..9e8b816 100644
--- a/sound/core/info_oss.c
+++ b/sound/core/info_oss.c
@@ -66,8 +66,6 @@ int snd_oss_info_register(int dev, int num, char *string)

 EXPORT_SYMBOL(snd_oss_info_register);

-extern void snd_card_info_read_oss(struct snd_info_buffer *buffer);
-
 static int snd_sndstat_show_strings(struct snd_info_buffer *buf, char *id, int dev)
 {
 	int idx, ok = -1;
