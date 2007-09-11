Return-Path: <linux-kernel-owner+w=401wt.eu-S1764113AbXIKSgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764113AbXIKSgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761419AbXIKSgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:36:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:28689 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760131AbXIKSgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:36:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cSKua6qenb1YdtSboLTK78WZ0UioOE/XrW7ugzJfWRxEJkVvrWt3eAQR6DjvfYALRsYHG2bSTLYwAcTt7XnTyLquP8EsuuG7VLaJrq04u8vPhf6i9lyCAxG7VlyZ1f62gFp2FuLfqWvAGaK9n3LnG0LvUoiDiT8taIwPUQLSl0U=
Message-ID: <a781481a0709111136s2a316878ra44230aaccefd48c@mail.gmail.com>
Date: Wed, 12 Sep 2007 00:06:11 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] always visit drivers/usb/misc/
Cc: "=?ISO-8859-1?Q?Toralf_F=F6rster?=" <toralf.foerster@gmx.de>,
       sean@mess.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <20070911171021.GO3563@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200709111606.24681.toralf.foerster@gmx.de>
	 <20070911171021.GO3563@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/11/07, Adrian Bunk <bunk@kernel.org> wrote:
> On Tue, Sep 11, 2007 at 04:06:21PM +0200, Toralf Förster wrote:
> > Hello,
> >
> > the build with the attached .config failed, make ends with:
> > ...
> >   AS      arch/i386/boot/compressed/head.o
> >   CC      arch/i386/boot/compressed/misc.o
> >   OBJCOPY arch/i386/boot/compressed/vmlinux.bin
> >   GZIP    arch/i386/boot/compressed/vmlinux.bin.gz
> >   LD      arch/i386/boot/compressed/piggy.o
> >   LD      arch/i386/boot/compressed/vmlinux
> >   OBJCOPY arch/i386/boot/vmlinux.bin
> >   HOSTCC  arch/i386/boot/tools/build
> >   BUILD   arch/i386/boot/bzImage
> > Root device is (3, 8)
> > Setup is 10456 bytes (padded to 10752 bytes).
> > System is 2531 kB
> > Kernel: arch/i386/boot/bzImage is ready  (#1)
> >   Building modules, stage 2.
> >   MODPOST 180 modules
> > ERROR: "phidget_class" [drivers/usb/misc/phidgetservo.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> >...
>
> The patch below fixes this constant source of problems.
>
> <--  snip  -->
>
> Currently, every driver under drivers/usb/misc/ also has to be listed in
> drivers/usb/Makefile. This has been forgotten more than once, and this
> patch changes drivers/usb/Makefile to simply always visit
> drivers/usb/misc/ when building the USB code.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Makes sense, I like the patch ...

Acked-by: Satyam Sharma <satyam@infradead.org>

> ---
>
>  drivers/usb/Makefile |   22 +---------------------
>  1 file changed, 1 insertion(+), 21 deletions(-)
>
> e03ef8eb70600ef876dda2cc30814e25b7d7fb07
> diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
> index ac49b15..516a640 100644
> --- a/drivers/usb/Makefile
> +++ b/drivers/usb/Makefile
> @@ -28,27 +28,7 @@ obj-$(CONFIG_USB_MICROTEK)   += image/
>
>  obj-$(CONFIG_USB_SERIAL)       += serial/
>
> -obj-$(CONFIG_USB_ADUTUX)       += misc/
> -obj-$(CONFIG_USB_APPLEDISPLAY) += misc/
> -obj-$(CONFIG_USB_AUERSWALD)    += misc/
> -obj-$(CONFIG_USB_BERRY_CHARGE) += misc/
> -obj-$(CONFIG_USB_CYPRESS_CY7C63)+= misc/
> -obj-$(CONFIG_USB_CYTHERM)      += misc/
> -obj-$(CONFIG_USB_EMI26)                += misc/
> -obj-$(CONFIG_USB_EMI62)                += misc/
> -obj-$(CONFIG_USB_FTDI_ELAN)    += misc/
> -obj-$(CONFIG_USB_IDMOUSE)      += misc/
> -obj-$(CONFIG_USB_LCD)          += misc/
> -obj-$(CONFIG_USB_LD)           += misc/
> -obj-$(CONFIG_USB_LED)          += misc/
> -obj-$(CONFIG_USB_LEGOTOWER)    += misc/
> -obj-$(CONFIG_USB_PHIDGETSERVO) += misc/
> -obj-$(CONFIG_USB_RIO500)       += misc/
> -obj-$(CONFIG_USB_SISUSBVGA)    += misc/
> -obj-$(CONFIG_USB_TEST)         += misc/
> -obj-$(CONFIG_USB_TRANCEVIBRATOR)+= misc/
> -obj-$(CONFIG_USB_USS720)       += misc/
> -obj-$(CONFIG_USB_IOWARRIOR)    += misc/
> +obj-$(CONFIG_USB)              += misc/
>
>  obj-$(CONFIG_USB_ATM)          += atm/
>  obj-$(CONFIG_USB_SPEEDTOUCH)   += atm/
>
