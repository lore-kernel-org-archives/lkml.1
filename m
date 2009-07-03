Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbZGCU12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbZGCU12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 16:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbZGCU1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 16:27:17 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:44306 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588AbZGCU1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 16:27:16 -0400
Date: Fri, 3 Jul 2009 13:26:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
       dbrownell@users.sourceforge.net
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       lud <linux-usb@vger.kernel.org>
Subject: [PATCH -next] gadget audio: select SND_PCM
Message-Id: <20090703132657.3289cdcf.randy.dunlap@oracle.com>
In-Reply-To: <20090703162443.16495147.sfr@canb.auug.org.au>
References: <20090703162443.16495147.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.4A4E6993.0105:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix USB gadget audio: select SND_PCM, like many other sound
drivers do, to fix build errors:

drivers/built-in.o: In function `f_audio_playback_work':
audio.c:(.text+0x15a3e7): undefined reference to `snd_pcm_kernel_ioctl'
audio.c:(.text+0x15a471): undefined reference to `snd_pcm_lib_write'
drivers/built-in.o: In function `_snd_pcm_hw_param_set':
audio.c:(.text+0x15aca7): undefined reference to `snd_interval_refine'
drivers/built-in.o: In function `gaudio_setup':
(.init.text+0x12adf): undefined reference to `_snd_pcm_hw_params_any'
drivers/built-in.o: In function `gaudio_setup':
(.init.text+0x12b43): undefined reference to `snd_pcm_kernel_ioctl'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/gadget/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090703.orig/drivers/usb/gadget/Kconfig
+++ linux-next-20090703/drivers/usb/gadget/Kconfig
@@ -604,6 +604,7 @@ config USB_ZERO_HNPTEST
 config USB_AUDIO
 	tristate "Audio Gadget (EXPERIMENTAL)"
 	depends on SND
+	select SND_PCM
 	help
 	  Gadget Audio is compatible with USB Audio Class specification 1.0.
 	  It will include at least one AudioControl interface, zero or more




---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
