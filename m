Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439Ab0AaP6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab0AaP6V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 10:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570Ab0AaP6U
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 10:58:20 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30021 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab0AaP6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 10:58:20 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5878"; a="33148334"
Subject: Re: [PATCH] staging/dream: add missing include files/fix
 compilation
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Iliyan Malchev <malchev@google.com>, linux-arm-msm@vger.kernel.org
In-Reply-To: <20100131092829.GJ2238@elf.ucw.cz>
References: <20091225205917.GA25761@elf.ucw.cz>
	 <20100115002419.GA25643@kroah.com> <20100119054516.GB22153@elf.ucw.cz>
	 <1263914079.1951.43.camel@m0nster> <20100131084421.GG2238@elf.ucw.cz>
	 <20100131092829.GJ2238@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Jan 2010 07:58:12 -0800
Message-ID: <1264953492.2059.5.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-31 at 10:28 +0100, Pavel Machek wrote:
> Hi!
> 
> > > > > > This adds missing include files, so it should now compile. ifdef
> > > > > > guards were added to Kconfig, so it should not cause problems on
> > > > > > non-arch-msm machines.
> > > > > > 
> > > > > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > > > 
> > > > > Odd, this doesn't apply to the linux-next tree, some of the files are
> > > > > already there.
> > > > 
> > > > Strange, it seems it is almost all already in. Well, good :-).
> > > > 
> > > > But there's small problem. linux-next now contains dwalker's tree, and
> > > > I could not get it to compile, even with staging disabled. I'll need
> > > > to look into that.
> > > 
> > > I worked on it a little, but I won't have time to really start cleaning
> > > up that tree till next week, or this weekend.
> > > 
> > > I pushed a new tree for next that should compile for dream with the
> > > attached config. I also included the patch that I added to get it to
> > > compile (you'll need the machine types too which I didn't include).
> > 
> > Thanks! I checked out linux-next version, and it seems to include
> > 
> > > commit cdf6c137865357112aa31666b65b938ab29fa736
> > >     msm: compile fixes for dream.
> > 
> > this patch. It still fails with:
> > 
> > arch/arm/mach-msm/rpc_hsusb.c: In function 'msm_chg_rpc_connect':
> > arch/arm/mach-msm/rpc_hsusb.c:156: error: implicit declaration of
> > function 'machine_is_msm7201a_surf'
> > arch/arm/mach-msm/rpc_hsusb.c:156: error: implicit declaration of
> > function 'machine_is_msm7x27_surf'
> > arch/arm/mach-msm/rpc_hsusb.c:157: error: implicit declaration of
> > function 'machine_is_qsd8x50_surf'
> > make[1]: *** [arch/arm/mach-msm/rpc_hsusb.o] Error 1
> > make: *** [arch/arm/mach-msm] Error 2
> > 
> > (and similar error further down). This fixes it, but you probably want
> > to add machine_is_* to your git. (Aha, is that what you meant by
> > "machine types"?
> > 
> > With this patch it compiles.
> 
> Ok, it compiles, but I do not see it booting. You config has:
> 
> CONFIG_MSM_DEBUG_UART=3
> # CONFIG_MSM_DEBUG_UART_NONE is not set
> # CONFIG_MSM_DEBUG_UART1 is not set
> # CONFIG_MSM_DEBUG_UART2 is not set
> CONFIG_MSM_DEBUG_UART3=y
> ...
> CONFIG_DEBUG_LL=y
> CONFIG_EARLY_PRINTK=y
> 
> set, so I'd expect it to say something on the serial line... (right?
> Or do I still need to patch printk.c to get that?). And I see nothing
> :-(.
> 
> I'm using
> 
> ./fastboot -c "console=ttyMSM2 root=/dev/mmcblk0p1 rootdelay=5 fbcon=rotate:1" boot /data/l/linux-dwalker/arch/arm/boot/zImage
> 
> ...with different kernel, it works (as in "I get most of the boot on
> serial line; it will not actually mount root").

Have you seen this error?

  GEN     /local/mnt/workspace/c_dwalke/git-trees/dream-test/Makefile
scripts/kconfig/conf -s arch/arm/Kconfig
  GEN     /local/mnt/workspace/c_dwalke/git-trees/dream-test/Makefile
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  Using /local/mnt/workspace/c_dwalke/git-trees/linux-2.6 as source for kernel
make[2]: `include/generated/mach-types.h' is up to date.
  CALL    /local/mnt/workspace/c_dwalke/git-trees/linux-2.6/scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  GZIP    kernel/config_data.gz
  IKCFG   kernel/config_data.h
  CC      kernel/configs.o
  LD      kernel/built-in.o
  CC      drivers/video/msm/msm_fb.o
  CC      drivers/video/cfbcopyarea.o
/home/dwalker/linux-2.6/drivers/video/msm/msm_fb.c:24: fatal error: linux/msm_mdp.h: No such file or directory
compilation terminated.
make[4]: *** [drivers/video/msm/msm_fb.o] Error 1
make[3]: *** [drivers/video/msm] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [drivers/video] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2

Even with the framebuffer off I still don't get any serial output on a
plain 2.6.33-rc6 .. I'm using a config that you sent me when you first
tested my -next tree .

Daniel

