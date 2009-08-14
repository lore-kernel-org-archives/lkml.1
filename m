Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbZHNOHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbZHNOHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 10:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbZHNOHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 10:07:43 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:56835 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbZHNOHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 10:07:42 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Aug 2009 10:07:42 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O7FgmbBwvZRZIo2K4ptQxiK6KFNDytjcQK5vecnj0npgW0eJWjTIsu+f01n86mh0a5
         oZfUlpIYN99FlJSGxSu06mmwLFMhN0gIARZ46EsJ/4TzW49A4Pmi9K5CtKCx9TN0obbu
         4TyNqeGoPqm3ytXLM4mRRKZKRIwRvVO8uPSdQ=
MIME-Version: 1.0
In-Reply-To: <4A856B13.90202@t-online.de>
References: <4A853ED8.9030800@t-online.de> <1250250242.5241.1395.camel@twins>
	 <4A856B13.90202@t-online.de>
Date: Fri, 14 Aug 2009 16:01:27 +0200
Message-ID: <b637ec0b0908140701r1d35e8daj15d47a246e865db8@mail.gmail.com>
Subject: Re: drm / i915 performance problems
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Peter Zijlstra <peterz@infradead.org>, airlied@linux.ie,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
Sorry if I jump in but as a former Opensuse 11.1 user I may have some
information. The problem is that the X.org version shipped with that
distro works fine only with 2.6.27.x kernels, regardless of the KMS
use.

If you want to use a newer kernel, you shoud get a 2.6.31-rc version
and a newer userspace. Please have a look at
http://bugzilla.kernel.org/show_bug.cgi?id=12950 .

If I remember correctly the solution was to add this repository:

    http://download.opensuse.org/repositories/X11:/XOrg/openSUSE_11.1/

to the repository list and then perform an update. Sorry but I left
Opensuse some months ago and my memory isn't helping a lot...

Hope this helps. Regards,
Fabio





On Fri, Aug 14, 2009 at 3:48 PM, Knut Petersen<Knut_Petersen@t-online.de> wrote:
> Peter Zijlstra schrieb:
>> I bet some people'd love to know what X.org version and intel drv
>> version you're using.
>>
>> Also, if you're having KMS enabled or not.
>>
>>
> Well, I doubt that Xorg is the problem as it perfectly works with older
> versions of the kernel.
>
> The problem is always present, no matter if
> - KMS is enabled or not
> - the agp/drm drivers are compiled as a module or compiled into the kernel
> - vesafb is used or not
> - tile blitting is enabled in framebuffer config space or not
>
> BTW: kernel 2.6.30.4 performs as bad as 2.6.31-rc6.
>
> From boot.log:
> <6>Linux agpgart interface v0.103
> <6>agpgart-intel 0000:00:00.0: Intel 915GM Chipset
> <6>agpgart-intel 0000:00:00.0: detected 7932K stolen memory
> <6>agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
> <6>[drm] Initialized drm 1.1.0 20060810
> <6>i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> <7>i915 0000:00:02.0: setting latency timer to 64
> <6>[drm] DAC-6: set mode 640x480 0
> <6>[drm] TV-12: set mode NTSC 480i 0
> <3>render error detected, EIR: 0x00000010
> <3>page table error
> <3>  PGTBL_ER: 0x00000010
> <3>[drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010, masking
> <3>render error detected, EIR: 0x00000010
> <3>page table error
> <3>  PGTBL_ER: 0x00000010
> <6>[drm] TMDS-8: set mode 1024x768 1a
> <4>Console: switching to colour frame buffer device 128x48
> <6>[drm] fb0: inteldrmfb frame buffer device
> <6>[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
>
>
> From the Xorg log:
>
> X.Org X Server 1.5.2
> Release Date: 10 October 2008
> X Protocol Version 11, Revision 0
> Build Operating System: openSUSE SUSE LINUX
> Current Operating System: Linux linux-golem 2.6.31-rc6-kape
> [...]
> (II) Loading /usr/lib/xorg/modules//drivers/intel_drv.so
> (II) Module intel: vendor="X.Org Foundation"
>        compiled for 1.5.2, module version = 2.5.0
>        Module class: X.Org Video Driver
>        ABI class: X.Org Video Driver, version 4.1
> [...](II) [drm] DRM interface version 1.3
> (II) [drm] DRM open master succeeded.
> (II) intel(0): [drm] Using the DRM lock SAREA also for drawables.
> (II) intel(0): [drm] framebuffer mapped by ddx driver
> (II) intel(0): [drm] added 1 reserved context for kernel
> (II) intel(0): X context handle = 0x1
> (II) intel(0): [drm] installed DRM signal handler
> (**) intel(0): Framebuffer compression enabled
> (**) intel(0): Tiling enabled
> (==) intel(0): VideoRam: 262144 KB
> (II) intel(0): Attempting memory allocation with tiled buffers.
> (EE) intel(0): Failed to set tiling on front buffer: Invalid argument
> (EE) intel(0): Failed to set tiling on back buffer: Invalid argument
> (EE) intel(0): Failed to set tiling on depth buffer: Invalid argument
> (II) intel(0): Tiled allocation successful.
> (II) intel(0): [drm] Registers = 0xd2300000
> (II) intel(0): [drm] Initialized kernel agp heap manager, 33554432
> (II) intel(0): [dri] visual configs initialized
> (II) intel(0): Page Flipping disabled
> (II) intel(0): vgaHWGetIOBase: hwp->IOBase is 0x03d0, hwp->PIOOffset is
> 0x000
> [...]
> (II) intel(0): Fixed memory allocation layout:
> (II) intel(0): 0x00000000-0x005fffff: compressed frame buffer (6144 kB,
> 0x000000007f800000 physical)
> (II) intel(0): 0x00600000-0x00600fff: compressed ll buffer (4 kB,
> 0x000000007fe00000 physical)
> (II) intel(0): 0x00601000-0x0060afff: HW cursors (40 kB,
> 0x000000007fe01000 physical)
> (II) intel(0): 0x0060b000-0x0060bfff: overlay registers (4 kB,
> 0x000000007fe0b000 physical)
> (II) intel(0): 0x007bf000:            end of stolen memory
> (II) intel(0): 0x007bf000-0x0bdd3fff: DRI memory manager (186452 kB)
> (II) intel(0): 0x0bdd4000-0x0d9f3fff: exa offscreen (28800 kB)
> (II) intel(0): 0x0d9f4000-0x0f9f3fff: classic textures (32768 kB)
> (II) intel(0): 0x10000000:            end of aperture
> (II) intel(0): BO memory allocation layout:
> (II) intel(0): 0x007bf000:            start of memory manager
> (II) intel(0): 0x007bf000-0x0111efff: depth buffer (9600 kB)
> (II) intel(0): 0x017bf000-0x0211efff: back buffer (9600 kB)
> (II) intel(0): 0x02800000-0x037fffff: front buffer (16384 kB)
> (II) intel(0): 0x027bf000-0x027c6fff: logical 3D context (32 kB)
> (II) intel(0): 0x0bdd4000:            end of memory manager
> (WW) intel(0): ESR is 0x00000010, page table error
> (WW) intel(0): PGTBL_ER is 0x00000010, display A pte
> (WW) intel(0): PRB0_CTL (0x0001f001) indicates ring buffer enabled
> (WW) intel(0): Existing errors found in hardware state.
> (II) intel(0): Selecting standard 18 bit TMDS pixel format.
> (II) intel(0): Output configuration:
> (II) intel(0):   Pipe A is on
> (II) intel(0):   Display plane A is now enabled and connected to pipe A.
> (II) intel(0):   Pipe B is on
> (II) intel(0):   Display plane B is now enabled and connected to pipe B.
> (II) intel(0):   Output VGA is connected to pipe none
> (II) intel(0):   Output LVDS is connected to pipe B
> (II) intel(0):   Output TMDS-1 is connected to pipe A
> (II) intel(0):   Output TV-2 is connected to pipe none
> (II) intel(0):   Output TV is connected to pipe none
> (II) intel(0): [drm] mapped front buffer at 0xc2800000, handle = 0xc2800000
> (II) intel(0): [drm] mapped back buffer at 0xc17bf000, handle = 0xc17bf000
> (II) intel(0): [drm] mapped depth buffer at 0xc07bf000, handle = 0xc07bf000
> (II) intel(0): [drm] mapped classic textures at 0xcd9f4000, handle =
> 0xcd9f4000
>
> cu,
>  Knut
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
