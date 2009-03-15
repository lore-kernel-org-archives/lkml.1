Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbZCOWGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbZCOWGE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 18:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZCOWFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 18:05:52 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:30083 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752373AbZCOWFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 18:05:51 -0400
X-Trace: 163746686/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.47.161/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.41.47.161
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8FAKYYvUlQKS+h/2dsb2JhbACBTc4tg38G
X-IronPort-AV: E=Sophos;i="4.38,368,1233532800"; 
   d="scan'208";a="163746686"
Subject: [PATCH] snd: aica - fix annoying compiler warning
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Alsa-devel <alsa-devel@lists.sourceforge.net>,
       Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 15 Mar 2009 22:05:40 +0000
Message-Id: <1237154740.6636.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cast pointer to data member of struct firmware as a void to end an
annoying compiler warning.

fix annoying compiler warning

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

diff --git a/sound/sh/aica.c b/sound/sh/aica.c
index 7c920f3..822b119 100644
--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -567,7 +567,7 @@ static int load_aica_firmware(void)
 		return err;
 	/* write firware into memory */
 	spu_disable();
-	spu_memload(0, fw_entry->data, fw_entry->size);
+	spu_memload(0, (void *)fw_entry->data, fw_entry->size);
 	spu_enable();
 	release_firmware(fw_entry);
 	return err;

