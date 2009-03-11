Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbZCKTL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbZCKTL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbZCKTLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:11:48 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:39728 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbZCKTLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:11:47 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: tiwai@suse.de
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH 2/2] sound: mixart, fix lock imbalance
Date: Wed, 11 Mar 2009 20:11:41 +0100
Message-Id: <1236798701-14332-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1236798701-14332-1-git-send-email-jirislaby@gmail.com>
References: <1236798701-14332-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an omitted unlock in one snd_mixart_hw_params fail path. Fix it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/mixart/mixart.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
index a593686..82bc5b9 100644
--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -607,6 +607,7 @@ static int snd_mixart_hw_params(struct snd_pcm_substream *subs,
 	/* set the format to the board */
 	err = mixart_set_format(stream, format);
 	if(err < 0) {
+		mutex_unlock(&mgr->setup_mutex);
 		return err;
 	}
 
-- 
1.6.2
caught by stanse

