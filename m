Return-Path: <linux-kernel-owner+w=401wt.eu-S1752273AbZGOG1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbZGOG1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 02:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZGOG1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 02:27:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:52643 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbZGOG1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 02:27:50 -0400
Subject: sound/pci/riptide/riptide.c compiler warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Jul 2009 11:57:30 +0530
Message-Id: <1247639250.2437.11.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting this compiler warning in linus tree :

  CC [M]  sound/pci/riptide/riptide.o
sound/pci/riptide/riptide.c: In function ‘alsa_card_riptide_init’:
sound/pci/riptide/riptide.c:2200: warning: ignoring return value of ‘__pci_register_driver’, declared with attribute warn_unused_result

This fixes the warning in my case, hope this will be helpful :

diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index 235a71e..fd8a552 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -2197,9 +2197,9 @@ static int __init alsa_card_riptide_init(void)
 	if (err < 0)
 		return err;
 #if defined(SUPPORT_JOYSTICK)
-	pci_register_driver(&joystick_driver);
+	err = pci_register_driver(&joystick_driver);
 #endif
-	return 0;
+	return err;
 }
 
 static void __exit alsa_card_riptide_exit(void)

--
JSR

