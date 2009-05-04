Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405AbZEDQXp (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 4 May 2009 12:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbZEDQXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:23:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:53035 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757890AbZEDQXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:23:13 -0400
X-Authenticated: #8143315
X-Provags-ID: V01U2FsdGVkX1+JbS9RD0WJQXoVt0lMrhZXMa5pOXXFz5/fqNRkmW
	l+uXcswot7bqQF
Content-Type: text/plain; charset=utf-8
To: =?utf-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>
Cc: "Jerome Glisse" <glisse@freedesktop.org>,
   "Shaohua Li" <shaohua.li@intel.com>, "Dave Airlie" <airlied@linux.ie>,
   "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
   "Andrew Morton" <akpm@linux-foundation.org>,
   "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
   "stable@kernel.org" <stable@kernel.org>
Subject: Re: PROBLEM: 2.6.29.2 - AGP doesn't work anymore on my nforce2
References: <op.us6ywl2jgp7xae@127.0.0.1>
 <20090430175927.a89f1cd3.akpm@linux-foundation.org>
 <1241179733.2606.1.camel@localhost.localdomain>
 <55bc079c-5c3d-465a-be28-0e38c0b48b14@rrsmsx603.amr.corp.intel.com>
 <20090504014151.GA22872@sli10-desk.sh.intel.com> <op.utd626zcgp7xae@127.0.0.1>
 <1241449660.24202.1041.camel@thor.local>
Date: Mon, 04 May 2009 18:23:03 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
FROM: Karsten Mehrhoff <kawime@gmx.de>
Message-ID: <op.uteygpgpgp7xae@127.0.0.1>
In-Reply-To: <1241449660.24202.1041.camel@thor.local>
User-Agent: Opera Mail/10.00 (Linux)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 May 2009 17:07:40 +0200, Michel Dänzer wrote:
> On Mon, 2009-05-04 at 08:31 +0200, Karsten Mehrhoff wrote:
>> On Mon, 04 May 2009 03:41:51 +0200, Shaohua Li wrote:
>>> On Fri, May 01, 2009 at 09:22:19PM +0800, kawime@gmx.de wrote:
>>>>> On Thu, 2009-04-30 at 17:59 -0700, Andrew Morton wrote:
>>>>>> On Thu, 30 Apr 2009 10:51:47 +0200
>>>>>> Karsten Mehrhoff wrote:
>>>>>>
>>>>>>> [1.]
>>>>>>> PROBLEM: No more agp card functionality with the patch 2.6.29.2 of
>>>>>> 'a/drivers/char/agp/generic.c'
>>>>>>>
>>>>>>> [2.]
>>>>>>> I compiled the kernel 2.6.29.2 with my .config of 2.6.29.1 and run
>>>>>> into problems with the speed of my ATI RADEON 9600 (rv350)
>>>>>>>
>>>>>>
>>>>>
>>>>> Is your problem speed issue ? ie just a slowdown ? Or does AGP stop
>>>>> working with this patch ? Slowdown is expected from this patch but
>>>>> it should hurt too much.
>>>>>
>>>>
>>>>                        2.6.29.1  | 2.6.29.2
>>>>                         --------  |  --------
>>>> glxgears             ~ 2900 FPS  |  ~ 75 FPS
>>>> glxgears -fullscreen ~  500 FPS  |  ~ 11 FPS
>>> Does this patch alone give so huge slowdown? From my little knowledge,
>>> xserver
>>> does agp pages allocation only at startup.
>>
>> I only reverted this patch in the source file  
>> (/drivers/char/agp/generic.c) and got back my old speed on 2.6.29.2.
>
> Is the DRI enabled in both cases? Compare the Xorg.0.log file and the
> output of
>
> dmesg|grep -e agp -e drm
>


*********************************
2.6.29.2 (original) 
*********************************

$ dmesg|grep -e agp -e drm
$ dmesg|grep agp
[    0.861997] Linux agpgart interface v0.103
[   10.893793] agpgart: Detected NVIDIA nForce2 chipset
[   10.939070] agpgart-nvidia 0000:00:00.0: AGP aperture is 64M @ 0xe0000000


$ glxinfo | grep direct
direct rendering: Yes


$ grep -i dri /var/log/Xorg.0.log
	X.Org Video Driver: 5.0
	X.Org XInput driver : 4.0
(II) LoadModule: "dri"
(II) Loading /usr/lib/xorg/modules/extensions//libdri.so
(II) Module dri: vendor="X.Org Foundation"
(II) Loading extension XFree86-DRI
(II) LoadModule: "dri2"
(II) Loading /usr/lib/xorg/modules/extensions//libdri2.so
(II) Module dri2: vendor="X.Org Foundation"
(II) Loading extension DRI2
(II) Scanning /usr/share/xserver-xorg/pci directory for additional PCI ID's supported by the drivers
(==) Matched radeon for the autoconfigured driver
(==) Assigned the driver to the xf86ConfigLayout
(II) Loading /usr/lib/xorg/modules/drivers//radeon_drv.so
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 5.0
(II) RADEON: Driver for ATI Radeon chipsets:
	ABI class: X.Org Video Driver, version 5.0
	ABI class: X.Org Video Driver, version 5.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: node name is /dev/dri/card0
(II) RADEON(0): [dri] Found DRI library version 1.3.0 and kernel module version 1.29.0
	ABI class: X.Org Video Driver, version 5.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: node name is /dev/dri/card0
(EE) RADEON(0): [agp] AGP failed to initialize. Disabling the DRI.
	ABI class: X.Org Video Driver, version 5.0
(II) AIGLX: Screen 0 is not DRI2 capable
(II) AIGLX: Screen 0 is not DRI capable
(II) AIGLX: Loaded and initialized /usr/lib/dri/swrast_dri.so
(II) GLX: Initialized DRISWRAST GL provider for screen 0
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 4.0



**********************************
2.6.29.2 (with the reverted patch)
**********************************

$ dmesg|grep -e agp -e drm
[    0.870790] Linux agpgart interface v0.103
[    0.871479] agpgart: Detected NVIDIA nForce2 chipset
[    0.877279] agpgart-nvidia 0000:00:00.0: AGP aperture is 64M @ 0xe0000000
[    0.878450] [drm] Initialized drm 1.1.0 20060810
[    0.881925] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   33.336636] agpgart-nvidia 0000:00:00.0: AGP 3.0 bridge
[   33.336658] agpgart-nvidia 0000:00:00.0: putting AGP V3 device into 8x mode
[   33.575910] [drm] Setting GART location based on new memory map
[   33.575922] [drm] Loading R300 Microcode
[   33.575965] [drm] Num pipes: 1
[   33.575973] [drm] writeback test succeeded in 1 usecs


$ glxinfo | grep direct
direct rendering: Yes


$ grep -i dri /var/log/Xorg.0.log
	X.Org Video Driver: 5.0
	X.Org XInput driver : 4.0
(II) LoadModule: "dri"
(II) Loading /usr/lib/xorg/modules/extensions//libdri.so
(II) Module dri: vendor="X.Org Foundation"
(II) Loading extension XFree86-DRI
(II) LoadModule: "dri2"
(II) Loading /usr/lib/xorg/modules/extensions//libdri2.so
(II) Module dri2: vendor="X.Org Foundation"
(II) Loading extension DRI2
(II) Scanning /usr/share/xserver-xorg/pci directory for additional PCI ID's supported by the drivers
(==) Matched radeon for the autoconfigured driver
(==) Assigned the driver to the xf86ConfigLayout
(II) Loading /usr/lib/xorg/modules/drivers//radeon_drv.so
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 5.0
(II) RADEON: Driver for ATI Radeon chipsets:
	ABI class: X.Org Video Driver, version 5.0
	ABI class: X.Org Video Driver, version 5.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: node name is /dev/dri/card0
(II) RADEON(0): [dri] Found DRI library version 1.3.0 and kernel module version 1.29.0
	ABI class: X.Org Video Driver, version 5.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: node name is /dev/dri/card0
(II) RADEON(0): [dri] Visual configs initialized
(II) RADEON(0): [DRI] installation complete
(WW) RADEON(0): DRI init changed memory map, adjusting ...
	ABI class: X.Org Video Driver, version 5.0
(II) AIGLX: Screen 0 is not DRI2 capable
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: node name is /dev/dri/card0
(II) AIGLX: enabled GLX_texture_from_pixmap with driver support
(II) AIGLX: Loaded and initialized /usr/lib/dri/r300_dri.so
(II) GLX: Initialized DRI GL provider for screen 0
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 4.0


For me it seems that agp failed to initialize because of the patch.
