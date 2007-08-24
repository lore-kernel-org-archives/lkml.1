Return-Path: <linux-kernel-owner+w=401wt.eu-S934120AbXHXAoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934120AbXHXAoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764573AbXHXAoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:44:03 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:7954 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760255AbXHXAoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:44:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=kIZvHfLeqmxfZfdqJG3usfWhPesvUpO6IDKAEiln33j0fBv8cB9LzhrTBAssEuSysvc83QPGl5BBbg4xxZSNGco44+aZkGCsD2RuSof3l/WJJn6KLZCAB+GLrZr8KCPzJmwB+Z6GT34D7+mWnFZOxeQgsLcAfnQYwEVA/yc10uk=
Message-Id: <74c9af7d8b52ce3da2de4a01916db664797b8d82.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:41:04 +0200
Subject: [PATCH 30/30] emu10k1: There's no need to cast vmalloc() return value in snd_emu10k1_create()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       James Courtier-Dutton <James@superbug.co.uk>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc() returns void *. no need to cast.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 sound/pci/emu10k1/emu10k1_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/emu10k1/emu10k1_main.c b/sound/pci/emu10k1/emu10k1_main.c
index 404ae1b..91d986b 100644
--- a/sound/pci/emu10k1/emu10k1_main.c
+++ b/sound/pci/emu10k1/emu10k1_main.c
@@ -1722,8 +1722,8 @@ int __devinit snd_emu10k1_create(struct snd_card *card,
 		goto error;
 	}
 
-	emu->page_ptr_table = (void **)vmalloc(emu->max_cache_pages * sizeof(void*));
-	emu->page_addr_table = (unsigned long*)vmalloc(emu->max_cache_pages * sizeof(unsigned long));
+	emu->page_ptr_table = vmalloc(emu->max_cache_pages * sizeof(void *));
+	emu->page_addr_table = vmalloc(emu->max_cache_pages * sizeof(unsigned long));
 	if (emu->page_ptr_table == NULL || emu->page_addr_table == NULL) {
 		err = -ENOMEM;
 		goto error;
-- 
1.5.2.2

