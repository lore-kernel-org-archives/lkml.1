Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbXHUUAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbXHUUAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbXHUUAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:00:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:42664 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbXHUUAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q3e7jG93OVcGtlXjX+afXbpziIP0xkrEldBYGwEWnHdc8fD72r4wNOoKoojQAEgcd7YVTcF7cGpg6UpnAVf0ZJmoYUWeZtwIJ8gbr5jiM5HWMkxlLoXS3g6DaoZKsDPNv1prCbSRN4xwpTOWt1fHtGVqHkmc9wZj9zh7aFZC70Y=
Message-ID: <5dc6fd9e0708211300p6a9e4c8o911e812293538f4c@mail.gmail.com>
Date: Tue, 21 Aug 2007 13:00:30 -0700
From: "Hex Star" <hexstar@gmail.com>
To: "=?ISO-8859-1?Q?Ismail_D=F6nmez?=" <ismail@pardus.org.tr>,
       linux-kernel@vger.kernel.org
Subject: Re: Trouble booting with new 2.6.22.3 kernel
In-Reply-To: <200708212256.59281.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <5dc6fd9e0708211219p679116a4n48765e72e2253ddc@mail.gmail.com>
	 <5dc6fd9e0708211226k3f931579x6f8b3ab275f93c35@mail.gmail.com>
	 <5dc6fd9e0708211227k22f9e214vd8132913214716b3@mail.gmail.com>
	 <200708212256.59281.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/07, Ismail Dönmez <ismail@pardus.org.tr> wrote:
> Well also the filesystem module for the root fs ( / ) should not be a module
> as you won't be able mount root at startup hence causing a panic.

Thanks, I have made sure that it is built in along with ata_piix
...however now I get this error:

[ 24.891879] ata_piix 0000:00:1f.2:invalid map value 0

But why do I get this error, if I run this script (which shows the
modules my system currently relies on):

#!/bin/bash
#
# find_all_modules.sh
#
for i in `find /sys/ -name modalias -exec cat {} \;`; do
    /sbin/modprobe --config /dev/null --show-depends $i ;
done | rev | cut -f 1 -d '/' | rev | sort -u

It outputs:

FATAL: Module pci:v00008086d00002448sv00000000sd00000000bc06sc04i01 not found.
FATAL: Module pci:v00008086d000027A3sv00000000sd00000000bc11sc01i00 not found.
FATAL: Module eisa not found.
FATAL: Module serial8250 not found.
agpgart.ko
appleir.ko
ata_generic.ko
ata_piix.ko
ath_hal.ko
ath_pci.ko
bluetooth.ko
ehci-hcd.ko
evbug.ko
evdev.ko
generic.ko
hci_usb.ko
hid.ko
i2c-algo-bit.ko
i2c-core.ko
i2c-i801.ko
ieee1394.ko
intel-agp.ko
intelfb.ko
intel-rng.ko
iTCO_vendor_support.ko
iTCO_wdt.ko
libata.ko
ohci1394.ko
pci_hotplug.ko
pcspkr.ko
scsi_mod.ko
shpchp.ko
sky2.ko
snd-hda-codec.ko
snd-hda-intel.ko
snd.ko
snd-page-alloc.ko
snd-pcm.ko
snd-timer.ko
soundcore.ko
tsdev.ko
uhci-hcd.ko
usbcore.ko
usbhid.ko
usbkbd.ko
usbmouse.ko
vesafb.ko
wlan.ko
xpad.ko

which shows that ata_piix is the controller for the hd correct? Is
this a bug or is there some special parameter I have to configure to
make this work? Thanks! :)
