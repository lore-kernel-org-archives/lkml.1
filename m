Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbZINHLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbZINHLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 03:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZINHLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 03:11:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39969 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbZINHLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:11:40 -0400
Date: Mon, 14 Sep 2009 09:11:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>, arve@android.com, swetland@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch] Re: newer version of HTC Dream support
Message-ID: <20090914071136.GB7146@elf.ucw.cz>
References: <20090911071155.GA1386@ucw.cz> <20090911075847.2fb7210a.randy.dunlap@oracle.com> <20090911161335.GA8137@elf.ucw.cz> <20090911092157.ba202b0a.randy.dunlap@oracle.com> <20090911212751.GA25544@elf.ucw.cz> <20090911153422.7d523a73.randy.dunlap@oracle.com> <20090913083719.GA6645@elf.ucw.cz> <20090913135422.f2d7cb88.randy.dunlap@oracle.com> <20090913223806.GB9522@elf.ucw.cz> <20090913162154.ee412cbe.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090913162154.ee412cbe.randy.dunlap@oracle.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > #obj-y += audio_out.o audio_in.o audio_mp3.o audmgr.o audpp.o
> > #obj-y += snd.o
> > 
> > from build, the rest should now build ok.
> 
> but still not link?
> 
> drivers/staging/dream/camera/msm_camera.c:1482: undefined reference to `msm_camera_flash_set_led_state'
> 
> CONFIG_MSM_CAMERA_FLASH=y

It should link with the patch below...

---

HTC Dream hardware has no camera flash, and current arm/mach-msm does
not have flash support. Disable flash support for now.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/dream/camera/Kconfig b/drivers/staging/dream/camera/Kconfig
index 0a3e903..bfb6d24 100644
--- a/drivers/staging/dream/camera/Kconfig
+++ b/drivers/staging/dream/camera/Kconfig
@@ -15,7 +15,7 @@ config MSM_CAMERA_DEBUG
 
 config MSM_CAMERA_FLASH
 	bool "Qualcomm MSM camera flash support"
-	depends on MSM_CAMERA
+	depends on MSM_CAMERA && BROKEN
 	---help---
 	  Enable support for LED flash for msm camera
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
