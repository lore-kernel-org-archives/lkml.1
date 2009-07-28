Return-Path: <linux-kernel-owner+w=401wt.eu-S1751016AbZG1Hb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751016AbZG1Hb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 03:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbZG1Hb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 03:31:29 -0400
Received: from smtp.witbe.net ([81.88.96.48]:48601 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbZG1Hb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 03:31:28 -0400
X-Greylist: delayed 884 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jul 2009 03:31:28 EDT
Date: Tue, 28 Jul 2009 09:16:22 +0200
From: Paul Rolland <rol@as2917.net>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: rol@witbe.net
Subject: Linux-2.6.31-rc4 - shut the annoying "failed to acquire vblank..."
Message-ID: <20090728091622.50e9933b@tux.DEF.witbe.net>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.2; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I sent a mail long ago about this message :
tux kernel: [drm:drm_wait_vblank] *ERROR* failed to acquire vblank counter,
-22 showing up more than 10 times per second, but was told that I had some
old userspace apps running... As I was using an old FC8, I forgot about it.

But I'm now running a quite recent FC11, pure 64bit machine, and when I run
a vanilla kernel, I have this message showing again and again.

I propose to apply the following patch :

--- drm_irq.c.orig      2009-07-26 21:36:20.000000000 +0200
+++ drm_irq.c   2009-07-26 21:36:34.000000000 +0200
@@ -566,7 +566,7 @@
 
        ret = drm_vblank_get(dev, crtc);
        if (ret) {
-               DRM_ERROR("failed to acquire vblank counter, %d\n", ret);
+               DRM_DEBUG("failed to acquire vblank counter, %d\n", ret);
                return ret;
        }
        seq = drm_vblank_count(dev, crtc);

to shut the message. This is at least what I do on my machine to have it
running quietly.

Anyway, if anyone care to explain why we have this "error", I'd be glad to
learn about it. 
And if anyone wants me to test some patches, I'll be glad to.

Regards,
Paul


-- 
Paul Rolland                                E-Mail : rol(at)witbe.net
CTO - Witbe.net SA                          Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un
navigateur "Some people dream of success... while others wake up and work
hard at it" 

"I worry about my child and the Internet all the time, even though she's
too young to have logged on yet. Here's what I worry about. I worry that 10
or 15 years from now, she will come to me and say 'Daddy, where were you
when they took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 
