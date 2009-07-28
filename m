Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbZG1QZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbZG1QZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbZG1QZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:25:49 -0400
Received: from outbound-mail-102.bluehost.com ([69.89.22.12]:58725 "HELO
	outbound-mail-102.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754667AbZG1QZs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:25:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=tDj3z2vySBTt72NMrUCCpJoOduMOajZAl2OfcndfvMhrWasY+b565ErgqvMN67khStboNzYGuG59/3KEBtPeIIXLlyFUqePO4QKzO+HuePJIsc2iqQ04n0zVN9ZbqMsJ;
Date: Tue, 28 Jul 2009 09:25:43 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, airlied@linux.ie
Subject: Re: Linux-2.6.31-rc4 - i915 errors
Message-ID: <20090728092543.0c096f79@jbarnes-g45>
In-Reply-To: <b637ec0b0907271220l62713fb8xfd35a12e50759641@mail.gmail.com>
References: <b637ec0b0907250230q659ea4cckc78e98a778d87207@mail.gmail.com>
	<20090727095940.28a94062@jbarnes-g45>
	<b637ec0b0907271220l62713fb8xfd35a12e50759641@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009 21:20:25 +0200
Fabio Comolli <fabio.comolli@gmail.com> wrote:

> Hi.
> 
> On Mon, Jul 27, 2009 at 6:59 PM, Jesse
> Barnes<jbarnes@virtuousgeek.org> wrote:
> > On Sat, 25 Jul 2009 11:30:42 +0200
> > Fabio Comolli <fabio.comolli@gmail.com> wrote:
> >
> >> Hi.
> >> At boot time my eeepc says:
> >>
> >> [    0.777082] render error detected, EIR: 0x00000010
> >> [    0.777086] page table error
> >> [    0.777089]   PGTBL_ER: 0x00000100
> >> [    0.777096] [drm:i915_driver_irq_handler] *ERROR* EIR stuck:
> >> 0x00000010, masking
> >> [    0.777105] render error detected, EIR: 0x00000010
> >> [    0.777108] page table error
> >> [    0.777111]   PGTBL_ER: 0x00000100
> >>
> >> with vanilla 2.6.31-rc4.
> >>
> >> Those lines weren't present with the previous kernels I used
> >> (2.6.29-stable). Everything works perfectly, actually better than
> >> ever.
> >
> > We recently added some error detection & reporting to the driver.
> >  On some machines it's picking up what I think are errors in the
> > initial mode programming (possibly by the BIOS), where the display
> > base pointers are pointing at invalid addresses.  We fix those up
> > shortly after loading the module so the error should be harmless,
> > but it would be nice to get rid of it.
> >
> 
> Also, I would like to add that it takes very long to initialize the fb
> device with KMS (7/10 of a second):
> 
> [    0.172408] [drm] Initialized drm 1.1.0 20060810
> [    0.172446] i915 0000:00:02.0: PCI INT A -> Link[LNKA] -> GSI 11
> (level, low) -> IRQ 11
> [    0.172455] i915 0000:00:02.0: setting latency timer to 64
> [    0.183493] i2c-adapter i2c-1: unable to read EDID block.
> [    0.183501] i915 0000:00:02.0: LVDS-1: no EDID data
> [    0.466653] [drm] DAC-6: set mode 640x480 0
> [    0.551026] i2c-adapter i2c-1: unable to read EDID block.
> [    0.551032] i915 0000:00:02.0: LVDS-1: no EDID data
> [    0.591925] [drm] TV-12: set mode NTSC 480i 0
> [    0.773675] render error detected, EIR: 0x00000010
> [    0.773679] page table error
> [    0.773682]   PGTBL_ER: 0x00000100
> [    0.773687] EIR stuck: 0x00000010, masking
> [    0.773695] render error detected, EIR: 0x00000010
> [    0.773698] page table error
> [    0.773701]   PGTBL_ER: 0x00000100
> [    0.779777] [drm] LVDS-8: set mode 1024x600 16
> [    0.865630] Console: switching to colour frame buffer device 128x37
> [    0.870711] [drm] fb0: inteldrmfb frame buffer device
> [    0.870725] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0
> on minor 0
> 
> When Xorg starts we wait another second here:
> 
> [    5.781313] [drm] DAC-6: set mode 640x480 0
> [    5.906817] [drm] DAC-6: set mode 640x480 0
> [    6.014119] i2c-adapter i2c-1: unable to read EDID block.
> [    6.014131] i915 0000:00:02.0: LVDS-1: no EDID data
> [    6.055283] [drm] TV-12: set mode NTSC 480i 0
> [    6.215041] [drm] TV-12: set mode NTSC 480i 0
> [    6.360195] [drm] DAC-6: set mode 640x480 0
> [    6.465721] [drm] DAC-6: set mode 640x480 0
> [    6.559368] i2c-adapter i2c-1: unable to read EDID block.
> [    6.559377] i915 0000:00:02.0: LVDS-1: no EDID data
> [    6.600574] [drm] TV-12: set mode NTSC 480i 0
> [    6.876347] [drm] TV-12: set mode NTSC 480i 0
> 
> Then 5 more seconds:
> 
> [    8.692507] [drm] DAC-6: set mode 640x480 0
> [    8.916223] [drm] DAC-6: set mode 640x480 0
> [    9.009504] i2c-adapter i2c-1: unable to read EDID block.
> [    9.009577] i915 0000:00:02.0: LVDS-1: no EDID data
> [    9.068467] [drm] TV-12: set mode NTSC 480i 0
> [   10.893694] [drm] TV-12: set mode NTSC 480i 0
> [   13.322289] [drm] DAC-6: set mode 640x480 0
> [   13.498363] [drm] DAC-6: set mode 640x480 0
> [   13.590332] i2c-adapter i2c-1: unable to read EDID block.
> [   13.590338] i915 0000:00:02.0: LVDS-1: no EDID data
> [   13.649226] [drm] TV-12: set mode NTSC 480i 0
> [   13.876217] [drm] TV-12: set mode NTSC 480i 0
> 
> Note: I stripped all the messages non-drm related.
> 
> Userspace is Xorg 1.6.2 with Intel driver 2.7.99.902 (the newest 2.8
> hasn't hit Archlinux repositories yet) with no xorg.conf .
> 
> In short, my system boots in 13 seconds; about half of those seem to
> be related to the i915 driver.
> 
> I would also like to add that this version of the drm driver, coupled
> with the latest versions of the Xorg userspace performs very well, the
> framerate in 3D apps is the highest ever and the picture quality is
> much better compared with 2.6.29.x
> 
> In other words, many thanks for your work.

Yeah we have some code to speed that up a bit on its way upstream.
Some of it is kernel code and some is user code, so to get the full
speedup you'll need to update both (when available, probably in the
next release).

-- 
Jesse Barnes, Intel Open Source Technology Center
