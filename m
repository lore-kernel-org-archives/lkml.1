Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbZINT42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbZINT42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 15:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbZINT41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 15:56:27 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:34410 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZINT40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 15:56:26 -0400
Date: Mon, 14 Sep 2009 12:56:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, arve@android.com, swetland@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch] Re: newer version of HTC Dream support
Message-Id: <20090914125620.81d98e1a.randy.dunlap@oracle.com>
In-Reply-To: <20090914071136.GB7146@elf.ucw.cz>
References: <20090911071155.GA1386@ucw.cz>
	<20090911075847.2fb7210a.randy.dunlap@oracle.com>
	<20090911161335.GA8137@elf.ucw.cz>
	<20090911092157.ba202b0a.randy.dunlap@oracle.com>
	<20090911212751.GA25544@elf.ucw.cz>
	<20090911153422.7d523a73.randy.dunlap@oracle.com>
	<20090913083719.GA6645@elf.ucw.cz>
	<20090913135422.f2d7cb88.randy.dunlap@oracle.com>
	<20090913223806.GB9522@elf.ucw.cz>
	<20090913162154.ee412cbe.randy.dunlap@oracle.com>
	<20090914071136.GB7146@elf.ucw.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4AAE9FE6.00BD:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 09:11:36 +0200 Pavel Machek wrote:

> Hi!
> 
> > > #obj-y += audio_out.o audio_in.o audio_mp3.o audmgr.o audpp.o
> > > #obj-y += snd.o
> > > 
> > > from build, the rest should now build ok.
> > 
> > but still not link?
> > 
> > drivers/staging/dream/camera/msm_camera.c:1482: undefined reference to `msm_camera_flash_set_led_state'
> > 
> > CONFIG_MSM_CAMERA_FLASH=y
> 
> It should link with the patch below...

Ack.  All built now.  Thanks.


> ---
> 
> HTC Dream hardware has no camera flash, and current arm/mach-msm does
> not have flash support. Disable flash support for now.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/drivers/staging/dream/camera/Kconfig b/drivers/staging/dream/camera/Kconfig
> index 0a3e903..bfb6d24 100644
> --- a/drivers/staging/dream/camera/Kconfig
> +++ b/drivers/staging/dream/camera/Kconfig
> @@ -15,7 +15,7 @@ config MSM_CAMERA_DEBUG
>  
>  config MSM_CAMERA_FLASH
>  	bool "Qualcomm MSM camera flash support"
> -	depends on MSM_CAMERA
> +	depends on MSM_CAMERA && BROKEN
>  	---help---
>  	  Enable support for LED flash for msm camera
>  
> 
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
