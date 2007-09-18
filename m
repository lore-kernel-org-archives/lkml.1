Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbXIRSfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbXIRSfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbXIRSex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:34:53 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:2943 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbXIRSew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:34:52 -0400
Message-ID: <46F01A39.3010104@linuxtv.org>
From: mkrufky@linuxtv.org
To: miles.lane@gmail.com
Cc: akpm@linux-foundation.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] 2.6.23-rc6-mm1 -- "dvb_dmx_swfilter"	[dr
	ivers/media/video/video-buf-dvb.ko] undefined!
Date: Tue, 18 Sep 2007 14:34:33 -0400
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2657.72)
user-agent: Thunderbird 2.0.0.6 (Windows/20070728)
in-reply-to: <a44ae5cd0709181117k7a563e66y8e01a64e5877cac8@mail.gmail.com>
x-originalarrivaltime: 18 Sep 2007 18:17:13.0159 (UTC) FILETIME=[22B5DD70:01C7FA20]
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C7FA20.229D9A80"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C7FA20.229D9A80
Content-Type: text/plain;
	charset="iso-8859-1"

Miles Lane wrote:
> ERROR: "dvb_dmx_swfilter" [drivers/media/video/video-buf-dvb.ko]
undefined!
> ERROR: "dvb_net_init" [drivers/media/video/video-buf-dvb.ko] undefined!
> ERROR: "dvb_dmxdev_init" [drivers/media/video/video-buf-dvb.ko] undefined!
> ERROR: "dvb_dmx_init" [drivers/media/video/video-buf-dvb.ko] undefined!
> ERROR: "dvb_register_frontend" [drivers/media/video/video-buf-dvb.ko]
undefined!
> ERROR: "dvb_register_adapter" [drivers/media/video/video-buf-dvb.ko]
undefined!
> ERROR: "dvb_unregister_adapter" [drivers/media/video/video-buf-dvb.ko]
> undefined!
> ERROR: "dvb_frontend_detach" [drivers/media/video/video-buf-dvb.ko]
undefined!
> ERROR: "dvb_unregister_frontend"
> [drivers/media/video/video-buf-dvb.ko] undefined!
> ERROR: "dvb_dmx_release" [drivers/media/video/video-buf-dvb.ko] undefined!
> ERROR: "dvb_dmxdev_release" [drivers/media/video/video-buf-dvb.ko]
undefined!
> ERROR: "dvb_net_release" [drivers/media/video/video-buf-dvb.ko] undefined!
> ERROR: "mt2131_attach" [drivers/media/video/cx23885/cx23885.ko] undefined!
> ERROR: "s5h1409_attach" [drivers/media/video/cx23885/cx23885.ko]
undefined!
>   

The attached fix should fix the problem.

Cheers,

Mike Krufky


------_=_NextPart_000_01C7FA20.229D9A80
Content-Type: text/plain;
	name="video-cx23885-depends-on-dvb-core.patch.txt"
Content-Disposition: attachment;
	filename="video-cx23885-depends-on-dvb-core.patch.txt"

# HG changeset patch
# User Michael Krufky <mkrufky@linuxtv.org>
# Date 1190132745 14400
# Node ID 67acaa106a99149264582873b12d0a46056a636c
# Parent  9c4007a4d0bdf54f807b78f8455a49e40577340d
VIDEO_CX23885 depends on DVB_CORE

From: Michael Krufky <mkrufky@linuxtv.org>

Fix the following dependency issue:

ERROR: "dvb_dmx_init" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_unregister_adapter" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_register_frontend" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_unregister_frontend" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_net_release" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_frontend_detach" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_dmxdev_release" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_dmx_swfilter" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_net_init" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_dmx_release" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_register_adapter" [drivers/media/video/video-buf-dvb.ko] undefined!
ERROR: "dvb_dmxdev_init" [drivers/media/video/video-buf-dvb.ko] undefined!

ERROR: "mt2131_attach" [drivers/media/video/cx23885/cx23885.ko] undefined!
ERROR: "s5h1409_attach" [drivers/media/video/cx23885/cx23885.ko] undefined!

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Steve Toth <stoth@hauppauge.com>

diff -r 9c4007a4d0bd -r 67acaa106a99 linux/drivers/media/video/cx23885/Kconfig
--- a/linux/drivers/media/video/cx23885/Kconfig	Tue Sep 18 10:06:25 2007 -0300
+++ b/linux/drivers/media/video/cx23885/Kconfig	Tue Sep 18 12:25:45 2007 -0400
@@ -1,6 +1,6 @@ config VIDEO_CX23885
 config VIDEO_CX23885
 	tristate "Conexant cx23885 (2388x successor) support"
-	depends on VIDEO_DEV && PCI && I2C
+	depends on DVB_CORE && VIDEO_DEV && PCI && I2C
 	select I2C_ALGOBIT
 	select FW_LOADER
 	select VIDEO_BTCX

------_=_NextPart_000_01C7FA20.229D9A80--
