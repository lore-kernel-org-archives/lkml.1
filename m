Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbXFWVlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbXFWVlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 17:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbXFWVlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 17:41:11 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:15650 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbXFWVlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 17:41:10 -0400
Date: Sat, 23 Jun 2007 14:41:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: perex@suse.cz, akpm <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] ALSA: fix section mismatch
Message-Id: <20070623144116.888fcb09.randy.dunlap@oracle.com>
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

Fix shared init/exit function attributes:
WARNING: sound/built-in.o(.exit.text+0x4a1): Section mismatch: reference to .init.text: (between 'alsa_card_virmidi_exit' and 'alsa_card_serial_exit')
WARNING: sound/built-in.o(.exit.text+0x4c1): Section mismatch: reference to .init.text: (between 'alsa_card_serial_exit' and 'ac97_bus_exit')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/drivers/serial-u16550.c |    2 +-
 sound/drivers/virmidi.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.22-rc5-git8.orig/sound/drivers/serial-u16550.c
+++ linux-2.6.22-rc5-git8/sound/drivers/serial-u16550.c
@@ -998,7 +998,7 @@ static struct platform_driver snd_serial
 	},
 };
 
-static void __init_or_module snd_serial_unregister_all(void)
+static void snd_serial_unregister_all(void)
 {
 	int i;
 
--- linux-2.6.22-rc5-git8.orig/sound/drivers/virmidi.c
+++ linux-2.6.22-rc5-git8/sound/drivers/virmidi.c
@@ -145,7 +145,7 @@ static struct platform_driver snd_virmid
 	},
 };
 
-static void __init_or_module snd_virmidi_unregister_all(void)
+static void snd_virmidi_unregister_all(void)
 {
 	int i;
 
