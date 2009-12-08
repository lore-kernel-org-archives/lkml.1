Return-Path: <linux-kernel-owner+w=401wt.eu-S937655AbZLHRN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937655AbZLHRN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 12:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937209AbZLHRNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 12:13:51 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:34545 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937631AbZLHRNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 12:13:49 -0500
Date: Tue, 8 Dec 2009 09:13:07 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Krzysztof Helt <krzysztof.h1@wp.pl>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] radio/sound/miro: fix build, cleanup depends/selects
Message-Id: <20091208091307.7bff5964.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B1E8938.008A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

miropcm20 uses ALSA (snd_) interfaces from the SND_MIRO
driver, so it should depend on SND.
(selecting SND_MIRO when CONFIG_SND is not enabled is a
problem.)

drivers/built-in.o: In function `vidioc_s_ctrl':
radio-miropcm20.c:(.text+0x227499): undefined reference to `snd_aci_cmd'
drivers/built-in.o: In function `vidioc_s_frequency':
radio-miropcm20.c:(.text+0x227574): undefined reference to `snd_aci_cmd'
radio-miropcm20.c:(.text+0x227588): undefined reference to `snd_aci_cmd'
drivers/built-in.o: In function `pcm20_init':
radio-miropcm20.c:(.init.text+0x2a784): undefined reference to `snd_aci_get_aci'

miropcm20 selects SND_MIRO but SND_ISA may be not enabled, so
also select SND_ISA so that the snd-miro driver will be built.
Otherwise there are missing symbols:

ERROR: "snd_opl4_create" [sound/isa/opti9xx/snd-miro.ko] undefined!
ERROR: "snd_wss_pcm" [sound/isa/opti9xx/snd-miro.ko] undefined!
ERROR: "snd_wss_timer" [sound/isa/opti9xx/snd-miro.ko] undefined!
ERROR: "snd_wss_create" [sound/isa/opti9xx/snd-miro.ko] undefined!
ERROR: "snd_wss_mixer" [sound/isa/opti9xx/snd-miro.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Takashi Iwai <tiwai@suse.de>
---
 drivers/media/radio/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20091204.orig/drivers/media/radio/Kconfig
+++ linux-next-20091204/drivers/media/radio/Kconfig
@@ -197,7 +197,8 @@ config RADIO_MAESTRO
 
 config RADIO_MIROPCM20
 	tristate "miroSOUND PCM20 radio"
-	depends on ISA && VIDEO_V4L2
+	depends on ISA && VIDEO_V4L2 && SND
+	select SND_ISA
 	select SND_MIRO
 	---help---
 	  Choose Y here if you have this FM radio card. You also need to enable
