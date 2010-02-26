Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537Ab0BZX0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 18:26:52 -0500
Received: from mail-yx0-f182.google.com ([209.85.210.182]:61873 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759524Ab0BZX0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 18:26:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=r6mh3AeCUX7dg8/Xu6TiECaigtBxGQcmZTrz9Bz/HiRQKV0pzgiNymPWOj+hN/YkYL
         rzFJbXLTunt20iCs09ZF9n6zF/mMLVUvMFJqkwjy2TwjUnAJcJ1mlzavj5yxwEr8dkC5
         EKW7PUcka7fzaYiKxAVUvhUPd7FYIPVACPuJI=
From: Ben Gardner <gardner.ben@gmail.com>
To: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Gardner <gardner.ben@gmail.com>,
       Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
Subject: [PATCH 3/3] OLPC: ALSA: fix cs5535audio's MIC GPIO to enable input
Date: Fri, 26 Feb 2010 17:26:26 -0600
Message-Id: <45a4e62ae577ae6cabce7e243e675b5e7d994ec2.1267225701.git.gardner.ben@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <cover.1267225701.git.gardner.ben@gmail.com>
References: <cover.1267225701.git.gardner.ben@gmail.com>
In-Reply-To: <cover.1267225701.git.gardner.ben@gmail.com>
References: <cover.1267225701.git.gardner.ben@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to read back the value written to the GPIO pin to control the
MIC input enable.
Use gpio_set_direction() to set the GPIO in bidirectional mode.

Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
CC: Andres Salomon <dilinger@collabora.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: David Brownell <dbrownell@users.sourceforge.net>
CC: Jani Nikula <ext-jani.1.nikula@nokia.com>
---
 sound/pci/cs5535audio/cs5535audio_olpc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
index 50da49b..0c80e67 100644
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -156,7 +156,7 @@ int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
 		printk(KERN_ERR DRV_NAME ": unable to allocate MIC GPIO\n");
 		return -EIO;
 	}
-	gpio_direction_output(OLPC_GPIO_MIC_AC, 0);
+	gpio_set_direction(OLPC_GPIO_MIC_AC, 3, 0);
 
 	/* drop the original AD1888 HPF control */
 	memset(&elem, 0, sizeof(elem));
-- 
1.7.0

