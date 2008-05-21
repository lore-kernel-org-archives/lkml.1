Return-Path: <linux-kernel-owner+w=401wt.eu-S1764854AbYEUSkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764854AbYEUSkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517AbYEUSj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:39:58 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:40618 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbYEUSj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:39:57 -0400
Date: Wed, 21 May 2008 11:37:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] sound/pcmcia/vx build error
Message-Id: <20080521113721.a9de4700.randy.dunlap@oracle.com>
In-Reply-To: <48346018.5040800@googlemail.com>
References: <48346018.5040800@googlemail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

menuconfig in Sound PCMCIA drivers needs to be tristate so that SND_PCMCIA
can have a value of m so that following drivers can be restricted to m
when needed.

sound/built-in.o: In function `vxpocket_detach':
vxpocket.c:(.text+0x20cfa): undefined reference to `pcmcia_disable_device'
sound/built-in.o: In function `vxpocket_probe':
vxpocket.c:(.text+0x20f46): undefined reference to `pcmcia_request_io'
vxpocket.c:(.text+0x20f5a): undefined reference to `pcmcia_request_irq'
vxpocket.c:(.text+0x20f73): undefined reference to `pcmcia_request_configuration'
vxpocket.c:(.text+0x2101f): undefined reference to `cs_error'
vxpocket.c:(.text+0x21027): undefined reference to `pcmcia_disable_device'
sound/built-in.o: In function `init_vxpocket':
vxpocket.c:(.init.text+0x75b): undefined reference to `pcmcia_register_driver'
sound/built-in.o: In function `exit_vxpocket':
vxpocket.c:(.exit.text+0x28c): undefined reference to `pcmcia_unregister_driver'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/pcmcia/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20080521.orig/sound/pcmcia/Kconfig
+++ linux-next-20080521/sound/pcmcia/Kconfig
@@ -1,7 +1,7 @@
 # ALSA PCMCIA drivers
 
 menuconfig SND_PCMCIA
-	bool "PCMCIA sound devices"
+	tristate "PCMCIA sound devices"
 	depends on PCMCIA
 	default y
 	help
