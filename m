Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbXFHOeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbXFHOeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbXFHOeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:34:07 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:37327 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbXFHOeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X2icm9CWP7AHV+Y7VoZ0W/S1KwKpB/8oBTrCB0mgZIWkPtLwJG/7E5qQX7FLNWkjC9VmdxYpk9BN+UezugpHcpIkSRZfGwd/Mvrn4P/2SsIziK4EO7zoxCMNH75IDOmBK+zP4q1nQNwRDfUrSVJ7y/GBouh1iwFjVkSDDyj1usY=
Message-ID: <9a8748490706080734h6ce5959fq6e7cb802d9a555cc@mail.gmail.com>
Date: Fri, 8 Jun 2007 16:34:01 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, jcm@jonmasters.org,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Andy Whitcroft" <apw@shadowen.org>, "Andrew Morton" <akpm@osdl.org>,
       "Randy Dunlap" <rdunlap@xenotime.net>,
       "Joel Schopp" <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070608123942.GZ5500@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
	 <9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com>
	 <Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr>
	 <20070607193413.GR5500@stusta.de>
	 <20070607232248.332edee8@the-village.bc.nu>
	 <20070607232152.GU5500@stusta.de>
	 <20070608004117.57868755@the-village.bc.nu>
	 <20070608000455.GW5500@stusta.de>
	 <20070608115219.694c642d@the-village.bc.nu>
	 <20070608123942.GZ5500@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/07, Adrian Bunk <bunk@stusta.de> wrote:
[snip]
>
> It's not only about MODULE_AUTHOR, if you consider it rude to limit
> people's names to ASCII, then don't forget that we have printk's like
>     Linux agpgart interface v0.102 (c) Dave Jones
>
> What happens if the maintainer changes and it's now
>      Linux agpgart interface v0.103 (c) Dave Ønes
>
> Does the console handle it correctly during boot?
> Can all tools that process the syslog cope with it?
>
> Perhaps the answer is in both cases "yes", but it's a completely
> untested area.
>
> We really must have all bugs shaken out and all users using fixed tools
> _before_ we can start outputting UTF-8 - limiting people's names to
> ASCII in not ideal, but IMHO causing breakages for users is a much
> bigger problem.
>

I haven't looked at it in depth yet, but it would seem we already have
a few files that need to be looked at with this in mind.  Looks like
it's not exactely a new problem (although all the following could be
in comments of course)...

$ find ./ -name "*.[ch]" | xargs file | grep -i utf
./arch/arm/mach-pxa/leds-trizeps4.c:                             UTF-8
Unicode C program text
./arch/arm/mach-pxa/trizeps4.c:                                  UTF-8
Unicode C program text
./arch/powerpc/platforms/cell/spufs/file.c:                      UTF-8
Unicode C program text
./drivers/acpi/asus_acpi.c:                               UTF-8
Unicode C program text
./drivers/char/drm/r128_drv.h:                            UTF-8
Unicode C program text
./drivers/char/drm/radeon_irq.c:                          UTF-8
Unicode C program text
./drivers/char/drm/drm_drawable.c:                        UTF-8
Unicode C program text
./drivers/char/drm/drm_pci.c:                             UTF-8
Unicode C program text
./drivers/char/drm/drm_core.h:                            UTF-8
Unicode C program text
./drivers/char/hw_random/omap-rng.c:                      UTF-8
Unicode C program text
./drivers/char/esp.c:                                     UTF-8
Unicode C program text
./drivers/char/watchdog/iTCO_vendor_support.c:            UTF-8
Unicode C program text
./drivers/i2c/busses/i2c-iop3xx.c:                        UTF-8
Unicode C program text
./drivers/infiniband/core/multicast.c:                    UTF-8
Unicode C program text
./drivers/infiniband/core/sa.h:                           UTF-8
Unicode C program text
./drivers/infiniband/core/sa_query.c:                     UTF-8
Unicode C program text
./drivers/mtd/chips/cfi_cmdset_0001.c:                    UTF-8
Unicode C program text
./drivers/mtd/chips/cfi_probe.c:                          UTF-8
Unicode C program text
./drivers/mtd/devices/block2mtd.c:                        UTF-8
Unicode C program text
./drivers/mtd/devices/phram.c:                            UTF-8
Unicode English text
./drivers/mtd/maps/cfi_flagadm.c:                         UTF-8
Unicode C program text
./drivers/mtd/maps/dbox2-flash.c:                         UTF-8
Unicode C program text
./drivers/mtd/maps/mtx-1_flash.c:                         UTF-8
Unicode C program text
./drivers/mtd/nand/ts7250.c:                              UTF-8
Unicode C program text
./drivers/mtd/nand/cafe_nand.c:                           UTF-8
Unicode C program text
./drivers/mtd/nand/cmx270_nand.c:                         UTF-8
Unicode C program text
./drivers/mtd/nand/cs553x_nand.c:                         UTF-8
Unicode C program text
./drivers/mtd/nand/edb7312.c:                             UTF-8
Unicode C program text
./drivers/mtd/nand/h1910.c:                               UTF-8
Unicode C program text
./drivers/mtd/mtdsuper.c:                                 UTF-8
Unicode C program text
./drivers/mtd/ubi/build.c:                                UTF-8
Unicode C program text
./drivers/mtd/ubi/cdev.c:                                 UTF-8
Unicode C program text
./drivers/mtd/ubi/debug.c:                                UTF-8
Unicode C program text
./drivers/mtd/ubi/debug.h:                                UTF-8
Unicode C program text
./drivers/mtd/ubi/gluebi.c:                               UTF-8
Unicode C program text
./drivers/mtd/ubi/io.c:                                   UTF-8
Unicode C program text
./drivers/mtd/ubi/kapi.c:                                 UTF-8
Unicode C program text
./drivers/mtd/ubi/misc.c:                                 UTF-8
Unicode C program text
./drivers/mtd/ubi/scan.c:                                 UTF-8
Unicode C program text
./drivers/mtd/ubi/scan.h:                                 UTF-8
Unicode C program text
./drivers/mtd/ubi/ubi.h:                                  UTF-8
Unicode C program text
./drivers/mtd/ubi/upd.c:                                  UTF-8
Unicode C program text
./drivers/mtd/ubi/vmt.c:                                  UTF-8
Unicode C program text
./drivers/mtd/ubi/vtbl.c:                                 UTF-8
Unicode C program text
./drivers/mtd/ubi/wl.c:                                   UTF-8
Unicode C program text
./drivers/mtd/ubi/eba.c:                                  UTF-8
Unicode C program text
./drivers/net/irda/toim3232-sir.c:                        UTF-8
Unicode English text
./drivers/net/irda/kingsun-sir.c:                         UTF-8
Unicode Pascal program text
./drivers/net/atl1/atl1_hw.h:                             UTF-8
Unicode C program text
./drivers/scsi/atari_NCR5380.c:
   UTF-8 Unicode C program text
./drivers/scsi/jazz_esp.c:
   UTF-8 Unicode C program text
./drivers/usb/misc/iowarrior.c:
   UTF-8 Unicode C program text
./drivers/usb/misc/auerswald.c:
   UTF-8 Unicode C program text
./drivers/video/atafb_iplan2p2.c:
   UTF-8 Unicode C program text
./drivers/video/atafb_iplan2p4.c:
   UTF-8 Unicode C program text
./drivers/video/atafb_iplan2p8.c:
   UTF-8 Unicode C program text
./fs/afs/afs_vl.h:
   UTF-8 Unicode C program text
./fs/jffs2/acl.c:
   UTF-8 Unicode C program text
./fs/jffs2/acl.h:
   UTF-8 Unicode C program text
./fs/jffs2/background.c:
   UTF-8 Unicode C program text
./fs/jffs2/build.c:
   UTF-8 Unicode C program text
./fs/jffs2/compr.c:
   UTF-8 Unicode C program text
./fs/jffs2/compr.h:
   UTF-8 Unicode C program text
./fs/jffs2/compr_rtime.c:
   UTF-8 Unicode C program text
./fs/jffs2/compr_rubin.c:
   UTF-8 Unicode C program text
./fs/jffs2/compr_zlib.c:
   UTF-8 Unicode C program text
./fs/jffs2/debug.c:
   UTF-8 Unicode C program text
./fs/jffs2/debug.h:
   UTF-8 Unicode C program text
./fs/jffs2/dir.c:
   UTF-8 Unicode C program text
./fs/jffs2/erase.c:
   UTF-8 Unicode C program text
./fs/jffs2/file.c:
   UTF-8 Unicode C program text
./fs/jffs2/fs.c:
   UTF-8 Unicode C program text
./fs/jffs2/gc.c:
   UTF-8 Unicode C program text
./fs/jffs2/ioctl.c:
   UTF-8 Unicode C program text
./fs/jffs2/jffs2_fs_i.h:
   UTF-8 Unicode C program text
./fs/jffs2/malloc.c:
   UTF-8 Unicode C program text
./fs/jffs2/nodelist.c:
   UTF-8 Unicode C program text
./fs/jffs2/nodelist.h:
   UTF-8 Unicode C program text
./fs/jffs2/os-linux.h:
   UTF-8 Unicode C program text
./fs/jffs2/read.c:
   UTF-8 Unicode C program text
./fs/jffs2/security.c:
   UTF-8 Unicode C program text
./fs/jffs2/summary.c:
   UTF-8 Unicode C program text
./fs/jffs2/summary.h:
   UTF-8 Unicode C program text
./fs/jffs2/symlink.c:
   UTF-8 Unicode C program text
./fs/jffs2/wbuf.c:
   UTF-8 Unicode C program text
./fs/jffs2/write.c:
   UTF-8 Unicode C program text
./fs/jffs2/xattr.h:
   UTF-8 Unicode C program text
./fs/jffs2/xattr_trusted.c:
   UTF-8 Unicode C program text
./fs/jffs2/xattr_user.c:
   UTF-8 Unicode C program text
./fs/jffs2/readinode.c:
   UTF-8 Unicode C program text
./fs/jffs2/super.c:
   UTF-8 Unicode C program text
./fs/jffs2/jffs2_fs_sb.h:
   UTF-8 Unicode C program text
./fs/jffs2/nodemgmt.c:
   UTF-8 Unicode C program text
./fs/jffs2/scan.c:
   UTF-8 Unicode C program text
./fs/jffs2/writev.c:
   UTF-8 Unicode C program text
./fs/jffs2/xattr.c:
   UTF-8 Unicode C program text
./fs/nls/nls_utf8.c:
   ASCII C program text
./include/asm-arm/arch-aaec2000/aaec2000.h:
   UTF-8 Unicode C program text
./include/asm-arm/arch-integrator/platform.h:
   UTF-8 Unicode C program text
./include/asm-arm/arch-omap/board.h:
   UTF-8 Unicode C program text
./include/asm-arm/arch-omap/dma.h:
   UTF-8 Unicode C program text
./include/asm-arm/arch-omap/gpio.h:
   UTF-8 Unicode C program text
./include/asm-arm/arch-pxa/trizeps4.h:
   UTF-8 Unicode C program text
./include/asm-m68k/atariints.h:                           UTF-8
Unicode C program text
./include/asm-m68k/atarihw.h:                             UTF-8
Unicode C program text
./include/asm-ppc/hydra.h:                                UTF-8
Unicode C program text
./include/linux/i2c-algo-bit.h:                           UTF-8
Unicode C program text
./include/linux/i2c-algo-pcf.h:                           UTF-8
Unicode C program text
./include/linux/i2c.h:                                    UTF-8
Unicode C program text
./include/linux/irda.h:                                   UTF-8
Unicode Pascal program text
./include/linux/meye.h:                                   UTF-8
Unicode C program text
./include/linux/mtd/super.h:                              UTF-8
Unicode C program text
./include/linux/mtd/mtd.h:                                UTF-8
Unicode C program text
./include/linux/mtd/ubi.h:                                UTF-8
Unicode C program text
./include/linux/sonypi.h:                                 UTF-8
Unicode C program text
./include/mtd/ubi-header.h:                               UTF-8
Unicode C program text
./include/mtd/ubi-user.h:                                 UTF-8
Unicode C program text
./include/net/irda/irda.h:                                UTF-8
Unicode Pascal program text
./include/net/irda/iriap.h:                               UTF-8
Unicode Pascal program text
./include/net/irda/iriap_event.h:                         UTF-8
Unicode Pascal program text
./include/net/irda/irias_object.h:                        UTF-8
Unicode Pascal program text
./include/net/irda/irlan_client.h:                        UTF-8
Unicode Pascal program text
./include/net/irda/irlan_common.h:                        UTF-8
Unicode Pascal program text
./include/net/irda/irlan_eth.h:                           UTF-8
Unicode Pascal program text
./include/net/irda/irlan_event.h:                         UTF-8
Unicode Pascal program text
./include/net/irda/irlan_filter.h:                        UTF-8
Unicode Pascal program text
./include/net/irda/irlan_provider.h:                      UTF-8
Unicode Pascal program text
./include/net/irda/irlap.h:                               UTF-8
Unicode Pascal program text
./include/net/irda/irlmp.h:                               UTF-8
Unicode Pascal program text
./include/net/irda/irlmp_event.h:                         UTF-8
Unicode Pascal program text
./include/net/irda/irlmp_frame.h:                         UTF-8
Unicode Pascal program text
./include/net/irda/irmod.h:                               UTF-8
Unicode Pascal program text
./include/net/irda/irqueue.h:                             UTF-8
Unicode English text
./include/net/irda/irttp.h:                               UTF-8
Unicode Pascal program text
./include/net/irda/parameters.h:                          UTF-8
Unicode Pascal program text
./include/net/irda/timer.h:                               UTF-8
Unicode Pascal program text
./include/net/irda/wrapper.h:                             UTF-8
Unicode Pascal program text
./include/net/irda/af_irda.h:                             UTF-8
Unicode Pascal program text
./kernel/sys.c:                                          UTF-8 Unicode
C program text
./sound/drivers/mts64.c:                                 UTF-8 Unicode
C program text
./sound/oss/es1371.c:                                    UTF-8 Unicode
C program text
./sound/oss/pas2_pcm.c:                                  UTF-8 Unicode
C program text
./sound/oss/trident.c:                                   UTF-8 Unicode
C program text
./sound/pci/ice1712/prodigy192.c:                        UTF-8 Unicode
C program text
./sound/pci/mixart/mixart.c:                             UTF-8 Unicode
C program text

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
