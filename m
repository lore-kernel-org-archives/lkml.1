Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbXEPHxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbXEPHxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 03:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbXEPHxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 03:53:36 -0400
Received: from fest.stud.feec.vutbr.cz ([147.229.72.16]:53964 "EHLO
	fest.stud.feec.vutbr.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbXEPHxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 03:53:35 -0400
Message-ID: <464AB84F.8060609@stud.feec.vutbr.cz>
Date: Wed, 16 May 2007 09:52:47 +0200
From: Schmidt Michal <xschmi00@stud.feec.vutbr.cz>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Robert Hancock <hancockr@shaw.ca>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [announce] Intel announces the PowerTOP utility for Linux
References: <fa.FTEkheuP0nHOUv0cCp0k8pBuoMU@ifi.uio.no> <4648FB1B.90208@shaw.ca> <200705151830.01891.linux@rainbow-software.org>
In-Reply-To: <200705151830.01891.linux@rainbow-software.org>
Content-Type: multipart/mixed;
 boundary="------------010901040505060707060407"
X-Spam-Score: -2.312 () BAYES_00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010901040505060707060407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ondrej Zary wrote:
> On Tuesday 15 May 2007 02:13:15 Robert Hancock wrote:
>> Looks like the radeon driver has the same problem as the i915 driver
>> mentioned on the known problems page - I get 60 wakeups/sec from it on
>> my Compaq X1000 laptop (Radeon 9000 graphics) while in X, which
>> essentially prevents entry into C3.
> 
> And Rage 128 too.
> 

I have a Radeon 7500 in my laptop. The attached hack to disable the 
VBLANK interrupt works for me. I don't know if it breaks 3D, I've only 
tried 2D.

Michal

--------------010901040505060707060407
Content-Type: text/plain;
 name="radeon-no-vblank-int.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="radeon-no-vblank-int.diff"

diff --git a/drivers/char/drm/radeon_irq.c b/drivers/char/drm/radeon_irq.c
index 3ff0baa..a990bb6 100644
--- a/drivers/char/drm/radeon_irq.c
+++ b/drivers/char/drm/radeon_irq.c
@@ -227,9 +227,8 @@ void radeon_driver_irq_postinstall(drm_device_t * dev)
 	atomic_set(&dev_priv->swi_emitted, 0);
 	DRM_INIT_WAITQUEUE(&dev_priv->swi_queue);
 
-	/* Turn on SW and VBL ints */
-	RADEON_WRITE(RADEON_GEN_INT_CNTL,
-		     RADEON_CRTC_VBLANK_MASK | RADEON_SW_INT_ENABLE);
+	/* Turn on the SW interrupt */
+	RADEON_WRITE(RADEON_GEN_INT_CNTL, RADEON_SW_INT_ENABLE);
 }
 
 void radeon_driver_irq_uninstall(drm_device_t * dev)

--------------010901040505060707060407--
