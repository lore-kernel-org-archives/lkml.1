Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbXFWV5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbXFWV5i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 17:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbXFWV5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 17:57:30 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:16607 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbXFWV5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 17:57:30 -0400
Date: Sat, 23 Jun 2007 14:58:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: perex@suse.cz, akpm <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] ALSA: more section mismatches
Message-Id: <20070623145848.da076328.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Something about __init_or_module isn't working as expected (?).
CONFIG_HOTPLUG=y
CONFIG_MODULES=n

Fix shared init/exit code helper:
WARNING: sound/built-in.o(.exit.text+0x243): Section mismatch: reference to .init.text: (between 'alsa_card_mpu401_exit' and 'ac97_bus_exit')
WARNING: sound/built-in.o(.exit.text+0x21b): Section mismatch: reference to .init.text: (between 'alsa_card_dummy_exit' and 'alsa_card_serial_exit')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/drivers/dummy.c         |    2 +-
 sound/drivers/mpu401/mpu401.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.22-rc5-git8.orig/sound/drivers/mpu401/mpu401.c
+++ linux-2.6.22-rc5-git8/sound/drivers/mpu401/mpu401.c
@@ -228,7 +228,7 @@ static struct pnp_driver snd_mpu401_pnp_
 static struct pnp_driver snd_mpu401_pnp_driver;
 #endif
 
-static void __init_or_module snd_mpu401_unregister_all(void)
+static void snd_mpu401_unregister_all(void)
 {
 	int i;
 
--- linux-2.6.22-rc5-git8.orig/sound/drivers/dummy.c
+++ linux-2.6.22-rc5-git8/sound/drivers/dummy.c
@@ -659,7 +659,7 @@ static struct platform_driver snd_dummy_
 	},
 };
 
-static void __init_or_module snd_dummy_unregister_all(void)
+static void snd_dummy_unregister_all(void)
 {
 	int i;
 
