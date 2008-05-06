Return-Path: <linux-kernel-owner+w=401wt.eu-S1762230AbYEFOyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230AbYEFOyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 10:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbYEFOyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 10:54:08 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:53215 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169AbYEFOyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 10:54:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kcG5bRpAyud67kIc6zGShxKLSf6RYr9CKpL1CEP0/Lp2lu7lUpGQ7g+f/o1Y74xdBZC/517tDZp6jgGE9RfdOUxiYSA33SyZQ5CM/Kw7LN4fXJHVrxkCWnpOYx4s67pHUN4BoksH/PdntqdFkQ7mqsgBba0nbLK1OhMDFTr+wGY=
Message-ID: <37219a840805060754j3c65d812l527d1837a5d95266@mail.gmail.com>
Date: Tue, 6 May 2008 10:54:02 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Mauro Carvalho Chehab via Mercurial" <mchehab@infradead.org>,
       "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] Fix FW_LOADER depencency at v4l/dvb
Cc: linuxtv-commits@linuxtv.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <E1JtNrl-0006mQ-MG@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1JtNrl-0006mQ-MG@www.linuxtv.org>
X-Google-Sender-Auth: 4cfff93ae100c2ad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro,

I disagree with this change.

It looks like you are attempting to workaround a Kbuild bug, by adding
additional dependencies to modules that select FW_LOADER.  Rather than
doing this, we should work on fixing Kbuild such that this situation
would be corrected.

Energy would be better spent fixing the Kbuild issue in the kernel
rather than working around the problem like this.

Meanwhile, this looks wrong to me.  These drivers are not necessarily
hotplug drivers, but I understand that Hotplug is a dependency of
FW_LOADER.  It seems to me that the firmware loader code could (and
should) be optimized such that it would no longer actually depend on
hotplug.

It's clear that there are two problems here.  #1, Kbuild needs fixing.
 #2, FW_LOADER depends on Hotplug, but not all users of FW_LOADER are
hotplug devices.

Working around these problems are really masking the real issues.  We
should not mask these issues -- we should get them fixed upstream,
instead.

I would rather not see this patch applied to the kernel.

Regards,

Mike

On Tue, May 6, 2008 at 10:10 AM, Patch from Mauro Carvalho Chehab
<hg-commit@linuxtv.org> wrote:
> The patch number 7851 was added via Mauro Carvalho Chehab <mchehab@infradead.org>
>  to http://linuxtv.org/hg/v4l-dvb master development tree.
>
>  Kernel patches in this development tree may be modified to be backward
>  compatible with older kernels. Compatibility modifications will be
>  removed before inclusion into the mainstream Kernel
>
>  If anyone has any objections, please let us know by sending a message to:
>         v4l-dvb-maintainer@linuxtv.org
>
>  ------
>
>  From: Mauro Carvalho Chehab  <mchehab@infradead.org>
>  Fix FW_LOADER depencency at v4l/dvb
>
>
>  Since:
>
>  1) FW_LOADER is defined as:
>
>  config FW_LOADER
>         tristate "Userspace firmware loading support"
>         depends on HOTPLUG
>
>  2) several V4L/DVB driver just selects it;
>
>  3) select is not smart enough to auto-select HOTPLUG, if select FW_LOADER.
>
>  So, All drivers that select FW_LOADER should also depend on HOTPLUG.
>
>  An easier solution (for the end-user perspective) would be to "select HOTPLUG".
>  However, live is not simple. This would cause recursive dependency issues like
>  this one:
>
>  drivers/usb/Kconfig:62:error: found recursive dependency: USB -> USB_OHCI_HCD
>  -> I2C -> MEDIA_TUNER -> MEDIA_TUNER_XC2028 -> HOTPLUG -> PCCARD -> PCMCIA ->
>  USB_ARCH_HAS_HCD -> MOUSE_APPLETOUCH -> USB
>
>  Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
>
>
>  ---
>
>   linux/drivers/media/common/tuners/Kconfig |    1 +
>   linux/drivers/media/dvb/bt8xx/Kconfig     |    1 +
>   linux/drivers/media/dvb/dvb-usb/Kconfig   |    1 +
>   linux/drivers/media/dvb/frontends/Kconfig |   16 ++++++++--------
>   linux/drivers/media/dvb/ttpci/Kconfig     |    2 ++
>   linux/drivers/media/dvb/ttusb-dec/Kconfig |    1 +
>   linux/drivers/media/video/bt8xx/Kconfig   |    1 +
>   linux/drivers/media/video/cx18/Kconfig    |    2 ++
>   linux/drivers/media/video/cx23885/Kconfig |    1 +
>   linux/drivers/media/video/cx25840/Kconfig |    1 +
>   linux/drivers/media/video/ivtv/Kconfig    |    2 ++
>   linux/drivers/media/video/pvrusb2/Kconfig |    1 +
>   linux/drivers/media/video/saa7134/Kconfig |    1 +
>   13 files changed, 23 insertions(+), 8 deletions(-)
>
>  diff -r 0f7c9a3a0fee -r 41b3f12d6ce4 linux/drivers/media/common/tuners/Kconfig
>  --- a/linux/drivers/media/common/tuners/Kconfig Tue May 06 10:47:44 2008 -0300
>  +++ b/linux/drivers/media/common/tuners/Kconfig Tue May 06 11:09:01 2008 -0300
>  @@ -131,6 +131,7 @@ config MEDIA_TUNER_XC2028
>
>   config MEDIA_TUNER_XC5000
>         tristate "Xceive XC5000 silicon tuner"
>  +       depends on HOTPLUG
>         select FW_LOADER
>         default m if DVB_FE_CUSTOMISE
>         help
>  diff -r 0f7c9a3a0fee -r 41b3f12d6ce4 linux/drivers/media/dvb/bt8xx/Kconfig
>  --- a/linux/drivers/media/dvb/bt8xx/Kconfig     Tue May 06 10:47:44 2008 -0300
>  +++ b/linux/drivers/media/dvb/bt8xx/Kconfig     Tue May 06 11:09:01 2008 -0300
>  @@ -1,6 +1,7 @@ config DVB_BT8XX
>   config DVB_BT8XX
>         tristate "BT8xx based PCI cards"
>         depends on DVB_CORE && PCI && I2C && VIDEO_BT848
>  +       depends on HOTPLUG      # due to FW_LOADER
>         select DVB_MT352 if !DVB_FE_CUSTOMISE
>         select DVB_SP887X if !DVB_FE_CUSTOMISE
>         select DVB_NXT6000 if !DVB_FE_CUSTOMISE
>  diff -r 0f7c9a3a0fee -r 41b3f12d6ce4 linux/drivers/media/dvb/dvb-usb/Kconfig
>  --- a/linux/drivers/media/dvb/dvb-usb/Kconfig   Tue May 06 10:47:44 2008 -0300
>  +++ b/linux/drivers/media/dvb/dvb-usb/Kconfig   Tue May 06 11:09:01 2008 -0300
>  @@ -1,6 +1,7 @@ config DVB_USB
>   config DVB_USB
>         tristate "Support for various USB DVB devices"
>         depends on DVB_CORE && USB && I2C
>  +       depends on HOTPLUG      # due to FW_LOADER
>         select FW_LOADER
>         help
>           By enabling this you will be able to choose the various supported
>  diff -r 0f7c9a3a0fee -r 41b3f12d6ce4 linux/drivers/media/dvb/frontends/Kconfig
>  --- a/linux/drivers/media/dvb/frontends/Kconfig Tue May 06 10:47:44 2008 -0300
>  +++ b/linux/drivers/media/dvb/frontends/Kconfig Tue May 06 11:09:01 2008 -0300
>  @@ -97,7 +97,7 @@ comment "DVB-T (terrestrial) frontends"
>
>   config DVB_SP8870
>         tristate "Spase sp8870 based"
>  -       depends on DVB_CORE && I2C
>  +       depends on DVB_CORE && I2C && HOTPLUG
>         default m if DVB_FE_CUSTOMISE
>         select FW_LOADER
>         help
>  @@ -110,7 +110,7 @@ config DVB_SP8870
>
>   config DVB_SP887X
>         tristate "Spase sp887x based"
>  -       depends on DVB_CORE && I2C
>  +       depends on DVB_CORE && I2C && HOTPLUG
>         default m if DVB_FE_CUSTOMISE
>         select FW_LOADER
>         help
>  @@ -158,7 +158,7 @@ config DVB_L64781
>
>   config DVB_TDA1004X
>         tristate "Philips TDA10045H/TDA10046H based"
>  -       depends on DVB_CORE && I2C
>  +       depends on DVB_CORE && I2C && HOTPLUG
>         default m if DVB_FE_CUSTOMISE
>         select FW_LOADER
>         help
>  @@ -225,7 +225,7 @@ config DVB_DIB7000P
>
>   config DVB_TDA10048
>         tristate "Philips TDA10048HN based"
>  -       depends on DVB_CORE && I2C
>  +       depends on DVB_CORE && I2C && HOTPLUG
>         default m if DVB_FE_CUSTOMISE
>         select FW_LOADER
>         help
>  @@ -267,7 +267,7 @@ comment "ATSC (North American/Korean Ter
>
>   config DVB_NXT200X
>         tristate "NxtWave Communications NXT2002/NXT2004 based"
>  -       depends on DVB_CORE && I2C
>  +       depends on DVB_CORE && I2C && HOTPLUG
>         default m if DVB_FE_CUSTOMISE
>         select FW_LOADER
>         help
>  @@ -282,7 +282,7 @@ config DVB_NXT200X
>
>   config DVB_OR51211
>         tristate "Oren OR51211 based"
>  -       depends on DVB_CORE && I2C
>  +       depends on DVB_CORE && I2C && HOTPLUG
>         default m if DVB_FE_CUSTOMISE
>         select FW_LOADER
>         help
>  @@ -295,7 +295,7 @@ config DVB_OR51211
>
>   config DVB_OR51132
>         tristate "Oren OR51132 based"
>  -       depends on DVB_CORE && I2C
>  +       depends on DVB_CORE && I2C && HOTPLUG
>         default m if DVB_FE_CUSTOMISE
>         select FW_LOADER
>         help
>  @@ -311,7 +311,7 @@ config DVB_OR51132
>
>   config DVB_BCM3510
>         tristate "Broadcom BCM3510"
>  -       depends on DVB_CORE && I2C
>  +       depends on DVB_CORE && I2C && HOTPLUG
>         default m if DVB_FE_CUSTOMISE
>         select FW_LOADER
>         help
>  diff -r 0f7c9a3a0fee -r 41b3f12d6ce4 linux/drivers/media/dvb/ttpci/Kconfig
>  --- a/linux/drivers/media/dvb/ttpci/Kconfig     Tue May 06 10:47:44 2008 -0300
>  +++ b/linux/drivers/media/dvb/ttpci/Kconfig     Tue May 06 11:09:01 2008 -0300
>  @@ -5,6 +5,7 @@ config DVB_AV7110
>   config DVB_AV7110
>         tristate "AV7110 cards"
>         depends on DVB_CORE && PCI && I2C
>  +       depends on HOTPLUG
>         select FW_LOADER if !DVB_AV7110_FIRMWARE
>         select TTPCI_EEPROM
>         select VIDEO_SAA7146_VV
>  @@ -123,6 +124,7 @@ config DVB_BUDGET_AV
>         depends on DVB_BUDGET_CORE && I2C
>         select VIDEO_SAA7146_VV
>         depends on VIDEO_DEV    # dependencies of VIDEO_SAA7146_VV
>  +       depends on HOTPLUG      # dependency of FW_LOADER
>         select DVB_PLL if !DVB_FE_CUSTOMISE
>         select DVB_STV0299 if !DVB_FE_CUSTOMISE
>         select DVB_TDA1004X if !DVB_FE_CUSTOMISE
>  diff -r 0f7c9a3a0fee -r 41b3f12d6ce4 linux/drivers/media/dvb/ttusb-dec/Kconfig
>  --- a/linux/drivers/media/dvb/ttusb-dec/Kconfig Tue May 06 10:47:44 2008 -0300
>  +++ b/linux/drivers/media/dvb/ttusb-dec/Kconfig Tue May 06 11:09:01 2008 -0300
>  @@ -1,6 +1,7 @@ config DVB_TTUSB_DEC
>   config DVB_TTUSB_DEC
>         tristate "Technotrend/Hauppauge USB DEC devices"
>         depends on DVB_CORE && USB
>  +       depends on HOTPLUG      # due to FW_LOADER
>         select FW_LOADER
>         select CRC32
>         help
>  diff -r 0f7c9a3a0fee -r 41b3f12d6ce4 linux/drivers/media/video/bt8xx/Kconfig
>  --- a/linux/drivers/media/video/bt8xx/Kconfig   Tue May 06 10:47:44 2008 -0300
>  +++ b/linux/drivers/media/video/bt8xx/Kconfig   Tue May 06 11:09:01 2008 -0300
>  @@ -1,6 +1,7 @@ config VIDEO_BT848
>   config VIDEO_BT848
>         tristate "BT848 Video For Linux"
>         depends on VIDEO_DEV && PCI && I2C && VIDEO_V4L2 && INPUT
>  +       depends on HOTPLUG      # due to FW_LOADER
>         select I2C_ALGOBIT
>         select FW_LOADER
>         select VIDEO_BTCX
>  diff -r 0f7c9a3a0fee -r 41b3f12d6ce4 linux/drivers/media/video/cx18/Kconfig
>  --- a/linux/drivers/media/video/cx18/Kconfig    Tue May 06 10:47:44 2008 -0300
>  +++ b/linux/drivers/media/video/cx18/Kconfig    Tue May 06 11:09:01 2008 -0300
>  @@ -1,6 +1,8 @@ config VIDEO_CX18
>   config VIDEO_CX18
>         tristate "Conexant cx23418 MPEG encoder support"
>         depends on VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL
>  +       depends on INPUT        # due to VIDEO_IR
>  +       depends on HOTPLUG      # due to FW_LOADER
>         select I2C_ALGOBIT
>         select FW_LOADER
>         select VIDEO_IR
>  diff -r 0f7c9a3a0fee -r 41b3f12d6ce4 linux/drivers/media/video/cx23885/Kconfig
>  --- a/linux/drivers/media/video/cx23885/Kconfig Tue May 06 10:47:44 2008 -0300
>  +++ b/linux/drivers/media/video/cx23885/Kconfig Tue May 06 11:09:01 2008 -0300
>  @@ -1,6 +1,7 @@ config VIDEO_CX23885
>   config VIDEO_CX23885
>         tristate "Conexant cx23885 (2388x successor) support"
>         depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT
>  +       depends on HOTPLUG      # due to FW_LOADER
>         select I2C_ALGOBIT
>         select FW_LOADER
>         select VIDEO_BTCX
>  diff -r 0f7c9a3a0fee -r 41b3f12d6ce4 linux/drivers/media/video/cx25840/Kconfig
>  --- a/linux/drivers/media/video/cx25840/Kconfig Tue May 06 10:47:44 2008 -0300
>  +++ b/linux/drivers/media/video/cx25840/Kconfig Tue May 06 11:09:01 2008 -0300
>  @@ -1,6 +1,7 @@ config VIDEO_CX25840
>   config VIDEO_CX25840
>         tristate "Conexant CX2584x audio/video decoders"
>         depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
>  +       depends on HOTPLUG # due to FW_LOADER
>         select FW_LOADER
>         ---help---
>           Support for the Conexant CX2584x audio/video decoders.
>  diff -r 0f7c9a3a0fee -r 41b3f12d6ce4 linux/drivers/media/video/ivtv/Kconfig
>  --- a/linux/drivers/media/video/ivtv/Kconfig    Tue May 06 10:47:44 2008 -0300
>  +++ b/linux/drivers/media/video/ivtv/Kconfig    Tue May 06 11:09:01 2008 -0300
>  @@ -1,6 +1,8 @@ config VIDEO_IVTV
>   config VIDEO_IVTV
>         tristate "Conexant cx23416/cx23415 MPEG encoder/decoder support"
>         depends on VIDEO_V4L1 && VIDEO_V4L2 && PCI && I2C && EXPERIMENTAL
>  +       depends on INPUT   # due to VIDEO_IR
>  +       depends on HOTPLUG # due to FW_LOADER
>         select I2C_ALGOBIT
>         select FW_LOADER
>         select VIDEO_IR
>  diff -r 0f7c9a3a0fee -r 41b3f12d6ce4 linux/drivers/media/video/pvrusb2/Kconfig
>  --- a/linux/drivers/media/video/pvrusb2/Kconfig Tue May 06 10:47:44 2008 -0300
>  +++ b/linux/drivers/media/video/pvrusb2/Kconfig Tue May 06 11:09:01 2008 -0300
>  @@ -1,6 +1,7 @@ config VIDEO_PVRUSB2
>   config VIDEO_PVRUSB2
>         tristate "Hauppauge WinTV-PVR USB2 support"
>         depends on VIDEO_V4L2 && I2C
>  +       depends on HOTPLUG      # due to FW_LOADER
>         select FW_LOADER
>         select VIDEO_TUNER
>         select VIDEO_TVEEPROM
>  diff -r 0f7c9a3a0fee -r 41b3f12d6ce4 linux/drivers/media/video/saa7134/Kconfig
>  --- a/linux/drivers/media/video/saa7134/Kconfig Tue May 06 10:47:44 2008 -0300
>  +++ b/linux/drivers/media/video/saa7134/Kconfig Tue May 06 11:09:01 2008 -0300
>  @@ -27,6 +27,7 @@ config VIDEO_SAA7134_DVB
>   config VIDEO_SAA7134_DVB
>         tristate "DVB/ATSC Support for saa7134 based TV cards"
>         depends on VIDEO_SAA7134 && DVB_CORE
>  +       depends on HOTPLUG      # due to FW_LOADER
>         select VIDEOBUF_DVB
>         select FW_LOADER
>         select DVB_PLL if !DVB_FE_CUSTOMISE
>
>
>  ---
>
>  Patch is available at: http://linuxtv.org/hg/v4l-dvb/rev/41b3f12d6ce4522213a28901757f26f7ef3d13d1
>
>  _______________________________________________
>  linuxtv-commits mailing list
>  linuxtv-commits@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
>
