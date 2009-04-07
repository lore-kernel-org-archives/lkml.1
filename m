Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbZDGQAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbZDGQAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757199AbZDGP7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:59:39 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:34897 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701AbZDGP7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:59:38 -0400
Message-ID: <49DB7861.5050606@oracle.com>
Date: Tue, 07 Apr 2009 08:59:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-media@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH -next] cx231xx: fix SND dependency build error
References: <20090407140717.a7f0b07c.sfr@canb.auug.org.au>
In-Reply-To: <20090407140717.a7f0b07c.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.49DB785A.0223:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Don't select VIDEO_CX231XX_ALSA when SND is not enabled since selecting it
won't cause SND to be enabled.

ERROR: "snd_pcm_period_elapsed" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!
ERROR: "snd_card_create" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!
ERROR: "snd_pcm_hw_constraint_integer" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!
ERROR: "snd_pcm_set_ops" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!
ERROR: "snd_pcm_lib_ioctl" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!
ERROR: "snd_card_free" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!
ERROR: "snd_card_register" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!
ERROR: "snd_pcm_new" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/cx231xx/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090407.orig/drivers/media/video/cx231xx/Kconfig
+++ linux-next-20090407/drivers/media/video/cx231xx/Kconfig
@@ -6,7 +6,7 @@ config VIDEO_CX231XX
        select VIDEO_IR
        select VIDEOBUF_VMALLOC
        select VIDEO_CX25840
-       select VIDEO_CX231XX_ALSA
+       select VIDEO_CX231XX_ALSA if SND
 
 	---help---
 	  This is a video4linux driver for Conexant 231xx USB based TV cards.
