Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbYKYKBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbYKYKBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYKYKBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:01:42 -0500
Received: from 89.6b.364a.static.theplanet.com ([74.54.107.137]:51610 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYKYKBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:01:41 -0500
Message-ID: <492BCD01.7080508@compulab.co.il>
Date: Tue, 25 Nov 2008 12:01:37 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Eric Miao <ymiao3@marvell.com>
CC: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/video/backlight: rename da903x to da903x_bl
References: <1227606164-12659-1-git-send-email-mike@compulab.co.il> <E913911567467945BBEB9277E27868B00153DC31@msiexch01.marvell.com>
In-Reply-To: <E913911567467945BBEB9277E27868B00153DC31@msiexch01.marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Eric Miao wrote:
> Isn't modprobe supposed to be smart enough for things like this?

Here's snap from build log:

mike@gentoodev /mnt/sdb1/git/linux-2.6-arm $ touch drivers/video/backlight/da903x.c
mike@gentoodev /mnt/sdb1/git/linux-2.6-arm $ touch drivers/regulator/da903x.c
mike@gentoodev /mnt/sdb1/git/linux-2.6-arm $ make O=/home/mike/arm/kernel/build/pxa/  modules
  CHK     include/linux/version.h
make[2]: `include/asm-arm/mach-types.h' is up to date.
  Using /mnt/sdb1/git/linux-2.6-arm as source for kernel
  GEN     /home/mike/arm/kernel/build/pxa/Makefile
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-arm
  CALL    /mnt/sdb1/git/linux-2.6-arm/scripts/checksyscalls.sh
<stdin>:1097:2: warning: #warning syscall fadvise64 not implemented
<stdin>:1265:2: warning: #warning syscall migrate_pages not implemented
<stdin>:1321:2: warning: #warning syscall pselect6 not implemented
<stdin>:1325:2: warning: #warning syscall ppoll not implemented
<stdin>:1365:2: warning: #warning syscall epoll_pwait not implemented
  CC [M]  drivers/regulator/da903x.o
  CC [M]  drivers/video/backlight/da903x.o
  Building modules, stage 2.
  MODPOST 70 modules
  LD [M]  drivers/video/backlight/da903x.ko
mike@gentoodev /mnt/sdb1/git/linux-2.6-arm $

So, apparently modpost is not smart enough for things like this :)

> I'm afraid if modprobe isn't so capable, we may encounter the same
> issue with other drivers and sometimes it is not so easy for
> developers of aphasia like me to choose a better name :)
> 
> - eric
> 
> -----Original Message-----
> From: Mike Rapoport [mailto:mike@compulab.co.il] 
> Sent: Tuesday, November 25, 2008 5:43 PM
> To: rpurdie@rpsys.net
> Cc: Eric Miao; linux-kernel@vger.kernel.org; Mike Rapoport
> Subject: [PATCH] drivers/video/backlight: rename da903x to da903x_bl
> 
> Currently both da903x backlight and voltage reulator drivers have the
> same name. Rename the backlight driver to allow use of both drivers as
> modules.
> 
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> ---
>  drivers/video/backlight/Makefile                  |    2 +-
>  drivers/video/backlight/{da903x.c => da903x_bl.c} |    0 
>  2 files changed, 1 insertions(+), 1 deletions(-)
>  rename drivers/video/backlight/{da903x.c => da903x_bl.c} (100%)
> 
> diff --git a/drivers/video/backlight/Makefile
> b/drivers/video/backlight/Makefile
> index 103427d..2d8f7cb 100644
> --- a/drivers/video/backlight/Makefile
> +++ b/drivers/video/backlight/Makefile
> @@ -18,7 +18,7 @@ obj-$(CONFIG_BACKLIGHT_OMAP1)	+= omap1_bl.o
>  obj-$(CONFIG_BACKLIGHT_PROGEAR) += progear_bl.o
>  obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
>  obj-$(CONFIG_BACKLIGHT_PWM)	+= pwm_bl.o
> -obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x.o
> +obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x_bl.o
>  obj-$(CONFIG_BACKLIGHT_MBP_NVIDIA) += mbp_nvidia_bl.o
>  obj-$(CONFIG_BACKLIGHT_TOSA)	+= tosa_bl.o
>  obj-$(CONFIG_BACKLIGHT_SAHARA)	+= kb3886_bl.o
> diff --git a/drivers/video/backlight/da903x.c
> b/drivers/video/backlight/da903x_bl.c
> similarity index 100%
> rename from drivers/video/backlight/da903x.c
> rename to drivers/video/backlight/da903x_bl.c

-- 
Sincerely yours,
Mike.


