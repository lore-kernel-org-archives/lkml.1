Return-Path: <linux-kernel-owner+w=401wt.eu-S1759995AbXFZW3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbXFZW3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758053AbXFZW23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:28:29 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:30602 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771AbXFZW21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:28:27 -0400
Date: Tue, 26 Jun 2007 15:30:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, perex@suse.cz
Subject: [PATCH -mm] ALSA portman2x4 section mismatch
Message-Id: <20070626153013.264f5a92.randy.dunlap@oracle.com>
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

FIx section mismatch when CONFIG_HOTPLUG=n:

WARNING: sound/built-in.o(.exit.text+0x271): Section mismatch: reference to .init.text:snd_p
ortman_unregister_all (between 'snd_portman_module_exit' and 'alsa_mpu401_uart_exit')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/drivers/portman2x4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.22-rc4-mm2.orig/sound/drivers/portman2x4.c
+++ linux-2.6.22-rc4-mm2/sound/drivers/portman2x4.c
@@ -833,7 +833,7 @@ static struct platform_driver snd_portma
 /*********************************************************************
  * module init stuff
  *********************************************************************/
-static void __init_or_module snd_portman_unregister_all(void)
+static void snd_portman_unregister_all(void)
 {
 	int i;
 
