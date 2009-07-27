Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZG0TU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZG0TU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 15:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbZG0TU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 15:20:27 -0400
Received: from mail-bw0-f221.google.com ([209.85.218.221]:50995 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbZG0TU1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 15:20:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pH/2CbbPuKI1GzodqE0HYiS9xyG6vjFx54KTOqcrDjvISH0zz2T6+NQZDNQWwH9uLL
         Ca+1luGRqEMed1z1syBcsGGw9/Mi+IPgkib20TEfSq3NLg5WHgZmqu1ZxdOqrMLiyu4t
         EMw/6qphFrnWPs1BY+P/lj+IBq//QSTBI0aqc=
MIME-Version: 1.0
In-Reply-To: <20090727095940.28a94062@jbarnes-g45>
References: <b637ec0b0907250230q659ea4cckc78e98a778d87207@mail.gmail.com>
	 <20090727095940.28a94062@jbarnes-g45>
Date: Mon, 27 Jul 2009 21:20:25 +0200
Message-ID: <b637ec0b0907271220l62713fb8xfd35a12e50759641@mail.gmail.com>
Subject: Re: Linux-2.6.31-rc4 - i915 errors
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, airlied@linux.ie
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, Jul 27, 2009 at 6:59 PM, Jesse Barnes<jbarnes@virtuousgeek.org> wrote:
> On Sat, 25 Jul 2009 11:30:42 +0200
> Fabio Comolli <fabio.comolli@gmail.com> wrote:
>
>> Hi.
>> At boot time my eeepc says:
>>
>> [    0.777082] render error detected, EIR: 0x00000010
>> [    0.777086] page table error
>> [    0.777089]   PGTBL_ER: 0x00000100
>> [    0.777096] [drm:i915_driver_irq_handler] *ERROR* EIR stuck:
>> 0x00000010, masking
>> [    0.777105] render error detected, EIR: 0x00000010
>> [    0.777108] page table error
>> [    0.777111]   PGTBL_ER: 0x00000100
>>
>> with vanilla 2.6.31-rc4.
>>
>> Those lines weren't present with the previous kernels I used
>> (2.6.29-stable). Everything works perfectly, actually better than
>> ever.
>
> We recently added some error detection & reporting to the driver.  On
> some machines it's picking up what I think are errors in the initial
> mode programming (possibly by the BIOS), where the display base
> pointers are pointing at invalid addresses.  We fix those up shortly
> after loading the module so the error should be harmless, but it would
> be nice to get rid of it.
>

Also, I would like to add that it takes very long to initialize the fb
device with KMS (7/10 of a second):

[    0.172408] [drm] Initialized drm 1.1.0 20060810
[    0.172446] i915 0000:00:02.0: PCI INT A -> Link[LNKA] -> GSI 11
(level, low) -> IRQ 11
[    0.172455] i915 0000:00:02.0: setting latency timer to 64
[    0.183493] i2c-adapter i2c-1: unable to read EDID block.
[    0.183501] i915 0000:00:02.0: LVDS-1: no EDID data
[    0.466653] [drm] DAC-6: set mode 640x480 0
[    0.551026] i2c-adapter i2c-1: unable to read EDID block.
[    0.551032] i915 0000:00:02.0: LVDS-1: no EDID data
[    0.591925] [drm] TV-12: set mode NTSC 480i 0
[    0.773675] render error detected, EIR: 0x00000010
[    0.773679] page table error
[    0.773682]   PGTBL_ER: 0x00000100
[    0.773687] EIR stuck: 0x00000010, masking
[    0.773695] render error detected, EIR: 0x00000010
[    0.773698] page table error
[    0.773701]   PGTBL_ER: 0x00000100
[    0.779777] [drm] LVDS-8: set mode 1024x600 16
[    0.865630] Console: switching to colour frame buffer device 128x37
[    0.870711] [drm] fb0: inteldrmfb frame buffer device
[    0.870725] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

When Xorg starts we wait another second here:

[    5.781313] [drm] DAC-6: set mode 640x480 0
[    5.906817] [drm] DAC-6: set mode 640x480 0
[    6.014119] i2c-adapter i2c-1: unable to read EDID block.
[    6.014131] i915 0000:00:02.0: LVDS-1: no EDID data
[    6.055283] [drm] TV-12: set mode NTSC 480i 0
[    6.215041] [drm] TV-12: set mode NTSC 480i 0
[    6.360195] [drm] DAC-6: set mode 640x480 0
[    6.465721] [drm] DAC-6: set mode 640x480 0
[    6.559368] i2c-adapter i2c-1: unable to read EDID block.
[    6.559377] i915 0000:00:02.0: LVDS-1: no EDID data
[    6.600574] [drm] TV-12: set mode NTSC 480i 0
[    6.876347] [drm] TV-12: set mode NTSC 480i 0

Then 5 more seconds:

[    8.692507] [drm] DAC-6: set mode 640x480 0
[    8.916223] [drm] DAC-6: set mode 640x480 0
[    9.009504] i2c-adapter i2c-1: unable to read EDID block.
[    9.009577] i915 0000:00:02.0: LVDS-1: no EDID data
[    9.068467] [drm] TV-12: set mode NTSC 480i 0
[   10.893694] [drm] TV-12: set mode NTSC 480i 0
[   13.322289] [drm] DAC-6: set mode 640x480 0
[   13.498363] [drm] DAC-6: set mode 640x480 0
[   13.590332] i2c-adapter i2c-1: unable to read EDID block.
[   13.590338] i915 0000:00:02.0: LVDS-1: no EDID data
[   13.649226] [drm] TV-12: set mode NTSC 480i 0
[   13.876217] [drm] TV-12: set mode NTSC 480i 0

Note: I stripped all the messages non-drm related.

Userspace is Xorg 1.6.2 with Intel driver 2.7.99.902 (the newest 2.8
hasn't hit Archlinux repositories yet) with no xorg.conf .

In short, my system boots in 13 seconds; about half of those seem to
be related to the i915 driver.

I would also like to add that this version of the drm driver, coupled
with the latest versions of the Xorg userspace performs very well, the
framerate in 3D apps is the highest ever and the picture quality is
much better compared with 2.6.29.x

In other words, many thanks for your work.

> --
> Jesse Barnes, Intel Open Source Technology Center
>

Regards,
Fabio
