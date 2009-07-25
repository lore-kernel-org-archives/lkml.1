Return-Path: <linux-kernel-owner+w=401wt.eu-S1751852AbZGYJVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbZGYJVM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 05:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbZGYJVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 05:21:10 -0400
Received: from mx6.orcon.net.nz ([219.88.242.56]:36904 "EHLO mx6.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbZGYJVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 05:21:07 -0400
Message-ID: <4A6ACE7C.9090409@orcon.net.nz>
Date: Sat, 25 Jul 2009 21:21:00 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
       xorg@lists.freedesktop.org
Subject: Re: Kernel 2.6.30.1 Oops on Alpha Architecture when starting Xserver
References: <4A5DB243.2000100@orcon.net.nz> <21d7e9970907152016u3b213beet9090ee3b34f6d8b1@mail.gmail.com>
In-Reply-To: <21d7e9970907152016u3b213beet9090ee3b34f6d8b1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx6.orcon.net.nz on Sat, 25 Jul 2009 21:21:03 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sat Jul 25 21:21:04 2009
X-DSPAM-Confidence: 0.9938
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCed to xorg email list since this might be an Xserver bug.]

Dave Airlie wrote:
> On Wed, Jul 15, 2009 at 8:41 PM, Michael Cree<mcree@orcon.net.nz> wrote:
>   
>> Kernel Oops on Alpha Architecture when starting the Xserver.
>>
>> Whenever I start the Xserver, version 1.6.2 from Debain Unstable, I get a
>> kernel oops report and the computer crashes hard; no ping response, hitting
>> the reset button to return to SRM fails.  Has caused corruption on disc
>> partitions on some crashes.  This occurs with kernels 2.6.30, 2.6.30.1 and
>> also a patched version of 2.6.29.x (patched so that I get PCI resource files
>> under sysfs).
>>
>> The kernel oops is:
>>     
>
> So its a machine check,
>   

So, does this indicate a software fault (e.g. inconsistencies in kernel 
data structures) or does it imply a hardware fault?

> Well X is trying to post the graphics card you have installed, and the machine
> is falling over when it does it.
>   

SRM (the equivalent of a BIOS) cannot post the card on startup.  But I 
have had the card (radeon rv610) post correctly and working in the past 
when I compiled the complete 1.5.3 Xserver myself.  I had it working 
with both the radeon and radeonhd drivers and a 2.6.29.x kernel patched 
to support libpciaccess.

Everything went to custard went I reinstalled and upgraded to Debian 
unstable.

As an experiment I have removed the Radeon rv610 card and installed a 
really old Sis variant video card.

The Xserver now displays a green screen and gets no further.  The 
machine no longer Oops.  Instead the Xserver sucks up near 100% CPU.  I 
connected to the Xorg process with gdb and got the following backtrace:

#0  0x00000200004fa7d8 in ?? () from /lib/libc.so.6.1
No symbol table info available.
#1  0x00000200004fa950 in inb () from /lib/libc.so.6.1
No symbol table info available.
#2  0x0000020000916fc0 in inb (port=986) at 
../../../../hw/xfree86/common/compiler.h:158
No locals.
#3  x_inb (port=986) at ../../../../hw/xfree86/int10/helper_exec.c:333
        val = 236 '\354'
#4  0x0000020000922c8c in x86emuOp_in_byte_AL_DX (op1=<value optimized out>)
    at ../../../../hw/xfree86/int10/../x86emu/ops.c:9737
No locals.
#5  0x0000020000937ddc in X86EMU_exec () at 
../../../../hw/xfree86/int10/../x86emu/decode.c:122
No locals.
#6  0x000002000091a0a8 in xf86ExecX86int10 (pInt=0x120293bc0)
    at ../../../../hw/xfree86/int10/xf86x86emu.c:40
No locals.
#7  0x000002000091b460 in xf86ExtendedInitInt10 (entityIndex=0, 
Flags=<value optimized out>)
    at ../../../../hw/xfree86/int10/generic.c:284
        pInt = <value optimized out>
        vbiosMem = 0x20000a14010
        options = 0x0
        screen = 0
        vga = {save_msr = 103 'g', save_pos102 = 255 '\377', save_vse = 
1 '\1', save_46e8 = 255 '\377'}
#8  0x00000200008f8c30 in VBEExtendedInit (pInt=0x0, entityIndex=0, Flags=3)
    at ../../../../hw/xfree86/vbe/vbe.c:69
        RealOff = <value optimized out>
        page = <value optimized out>
        pScrn = <value optimized out>
        init_int10 = 0
        vip = <value optimized out>
        screen = 0
#9  0x0000020000840f94 in SiS_LoadInitVBE (pScrn=0x120291c80) at 
../../src/sis_driver.c:2956
        pSiS = 0x120294810
#10 0x00000200008475c8 in SISPreInit (pScrn=0x120291c80, flags=<value 
optimized out>)
    at ../../src/sis_driver.c:6125
        pSiSEnt = 0x0
        from = X_PROBED
        usScratchCR17 = 41 ')'
        usScratchCR32 = 176 '\260'
        usScratchCR63 = 84 'T'
        usScratchSR1F = 223 '\337'
        srlockReg = 33 '!'
        crlockReg = 33 '!'
        i = <value optimized out>
        pix24flags = 41
        clockRanges = <value optimized out>
        pMonitor = 0x2
        fromDDC = <value optimized out>
        crlockReg = 33 '!'
        i = <value optimized out>
        pix24flags = 41
        clockRanges = <value optimized out>
        pMonitor = 0x2
        fromDDC = <value optimized out>
---Type <return> to continue, or q <return> to quit---
        crt1freqoverruled = <value optimized out>
        CR5F = 2 '\2'
        first = <value optimized out>
        p = <value optimized out>
        n = <value optimized out>
        crt2freqoverruled = <value optimized out>
        ddcsstr = 0x2000088731e "CRT%d DDC monitor info: ", '*' <repeats 
43 times>, "\n"
        ddcestr = 0x200008872d9 "End of CRT%d DDC monitor info ", '*' 
<repeats 37 times>, "\n"
        subshstr = 0x2000088729d "Substituting missing CRT%d monitor 
HSync range by DDC data\n"
        subsvstr = 0x2000088725e "Substituting missing CRT%d monitor 
VRefresh range by DDC data\n"
        saneh = 0x20000887235 "Correcting %s CRT%d monitor HSync range\n"
        sanev = 0x20000887209 "Correcting %s CRT%d monitor VRefresh range\n"
        mergednocrt1 = 0x200008871e3 "CRT1 not detected or forced off. 
%s.\n"
        mergednocrt2 = 0x200008871a9 "No CRT2 output selected or no 
video bridge detected. %s.\n"
        mergeddisstr = 0x20000887192 "MergedFB mode disabled"
        modesforstr = 0x2000088714d "Modes for CRT%d: ", '*' <repeats 50 
times>, "\n"
        crtsetupstr = 0x20000887108 '*' <repeats 27 times>, " CRT%d 
setup ", '*' <repeats 27 times>, "\n"
        crt2monname = 0x2000088a47f "CRT2"
        notsuitablestr = 0x200008870d8 "Not using mode \"%s\" (not 
suitable for %s mode)\n"
        id650str = {0x200008870cc "650", 0x200008870cc "650", 
0x200008870cc "650",
          0x200008870cc "650", 0x20000887090 "650 A0 AA", 0x2000088709a 
"650 A2 CA",
          0x200008870cc "650", 0x200008870cc "650", 0x200008870a4 "M650 
A0",
          0x200008870ac "M650 A1 AA", 0x200008870b7 "651 A0 AA", 
0x200008870c1 "651 A1 AA",
          0x200008870cb "M650", 0x200008870d0 "65?", 0x200008870d4 
"651", 0x200008870d0 "65?"}
#11 0x000000012008b7c4 in InitOutput (pScreenInfo=0x1202700e0, argc=3, 
argv=0x11f9d1c38)
    at ../../../../hw/xfree86/common/xf86Init.c:1008
        i = 0
        j = <value optimized out>
        k = <value optimized out>
        modulelist = <value optimized out>
        optionlist = 0x120284530
        layout = <value optimized out>
        screenpix24 = <value optimized out>
        pix24 = <value optimized out>
        pix24From = <value optimized out>
        autoconfig = <value optimized out>
        configured_device = <value optimized out>
#12 0x000000012003234c in main (argc=3, argv=0x11f9d1c38, 
envp=0x11f9d1c58) at ../../dix/main.c:315
        i = 536878123
        alwaysCheckForInput = {0, 1}


The Xorg.0.log is:

X.Org X Server 1.6.2
Release Date: 2009-7-7
X Protocol Version 11, Revision 0
Build Operating System: Linux 2.6.26-2-alpha-generic alpha Debian
Current Operating System: Linux aleph 2.6.30.1-miata #1 Fri Jul 3 
22:54:36 NZST 2009 alpha
Build Date: 13 July 2009  10:58:49PM
xorg-server 2:1.6.2-1 (buildd@goetz.debian.org)
        Before reporting problems, check http://wiki.x.org
        to make sure that you have the latest version.
Markers: (--) probed, (**) from config file, (==) default setting,
        (++) from command line, (!!) notice, (II) informational,
        (WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Sat Jul 25 20:56:41 2009
(==) Using config file: "/etc/X11/xorg.conf"
(==) No Layout section.  Using the first Screen section.
(==) No screen section available. Using defaults.
(**) |-->Screen "Default Screen Section" (0)
(**) |   |-->Monitor "<default monitor>"
(==) No device specified for screen "Default Screen Section".
        Using the first device section listed.
(**) |   |-->Device "Configured Video Device"
(==) No monitor specified for screen "Default Screen Section".
        Using a default monitor configuration.
(**) Option "AllowEmptyInput" "off"
(==) Automatically adding devices
(==) Automatically enabling devices
(WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
        Entry deleted from font path.
(==) FontPath set to:
        /usr/share/fonts/X11/misc,
        /usr/share/fonts/X11/100dpi/:unscaled,
        /usr/share/fonts/X11/75dpi/:unscaled,
        /usr/share/fonts/X11/Type1,
        /usr/share/fonts/X11/100dpi,
        /usr/share/fonts/X11/75dpi,
        /var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
        built-ins
(==) ModulePath set to "/usr/lib/xorg/modules"
(==) |-->Input Device "Configured Mouse"
(==) |-->Input Device "Generic Keyboard"
(==) No Layout section. Using the first mouse device.
(==) No Layout section. Using the first keyboard device.
(II) Loader magic: 0x1d00
(II) Module ABI versions:
        X.Org ANSI C Emulation: 0.4
        X.Org Video Driver: 5.0
        X.Org XInput driver : 4.0
        X.Org Server Extension : 2.0
(II) Loader running on linux
(--) using VT number 3

(--) PCI:*(0:0:12:0) 1039:6326:1039:6326 Silicon Integrated Systems 
[SiS] 86C326 5598/6326 rev 11, Mem @ 0x09000000/8388608, 
0x09a50000/65536, I/O @ 0x00009080/128, BIOS @ 0x????????/65536
(II) No APM support in BIOS or kernel
(II) System resource ranges:
(II) LoadModule: "extmod"
(II) Loading /usr/lib/xorg/modules/extensions//libextmod.so
(II) Module extmod: vendor="X.Org Foundation"
        compiled for 1.6.2, module version = 1.0.0
        Module class: X.Org Server Extension
        ABI class: X.Org Server Extension, version 2.0
(II) Loading extension SELinux
(II) Loading extension MIT-SCREEN-SAVER
(II) Loading extension XFree86-VidModeExtension
(II) Loading extension XFree86-DGA
(II) Loading extension DPMS
(II) Loading extension XVideo
(II) Loading extension XVideo-MotionCompensation
(II) Loading extension X-Resource
(II) LoadModule: "dbe"
(II) Loading /usr/lib/xorg/modules/extensions//libdbe.so
(II) Module dbe: vendor="X.Org Foundation"
        compiled for 1.6.2, module version = 1.0.0
        Module class: X.Org Server Extension
        ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DOUBLE-BUFFER
(II) LoadModule: "glx"
(II) Loading /usr/lib/xorg/modules/extensions//libglx.so
(II) Module glx: vendor="X.Org Foundation"
        compiled for 1.6.2, module version = 1.0.0
        ABI class: X.Org Server Extension, version 2.0
(==) AIGLX enabled
(II) Loading extension GLX
(II) LoadModule: "record"
(II) Loading /usr/lib/xorg/modules/extensions//librecord.so
(II) Module record: vendor="X.Org Foundation"
        compiled for 1.6.2, module version = 1.13.0
        Module class: X.Org Server Extension
        ABI class: X.Org Server Extension, version 2.0
(II) Loading extension RECORD
(II) LoadModule: "dri"
(II) Loading /usr/lib/xorg/modules/extensions//libdri.so
(II) Module dri: vendor="X.Org Foundation"
        compiled for 1.6.2, module version = 1.0.0
        ABI class: X.Org Server Extension, version 2.0
(II) Loading extension XFree86-DRI
(II) LoadModule: "dri2"
(II) Loading /usr/lib/xorg/modules/extensions//libdri2.so
(II) Module dri2: vendor="X.Org Foundation"
        compiled for 1.6.2, module version = 1.1.0
        ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DRI2
(==) Matched sis for the autoconfigured driver
(==) Assigned the driver to the xf86ConfigLayout
(II) LoadModule: "sis"
(II) Loading /usr/lib/xorg/modules/drivers//sis_drv.so
(II) Module sis: vendor="X.Org Foundation"
        compiled for 1.6.2, module version = 0.10.1
        Module class: X.Org Video Driver
        ABI class: X.Org Video Driver, version 5.0
(II) LoadModule: "mouse"
(II) Loading /usr/lib/xorg/modules/input//mouse_drv.so
(II) Module mouse: vendor="X.Org Foundation"
        compiled for 1.6.1, module version = 1.4.0
        Module class: X.Org XInput Driver
        ABI class: X.Org XInput driver, version 4.0
(II) LoadModule: "kbd"
(II) Loading /usr/lib/xorg/modules/input//kbd_drv.so
(II) Module kbd: vendor="X.Org Foundation"
        compiled for 1.6.1, module version = 1.3.2
        Module class: X.Org XInput Driver
        ABI class: X.Org XInput driver, version 4.0
(II) SIS: driver for SiS chipsets: SIS5597/5598, SIS530/620,
        SIS6326/AGP/DVD, SIS300/305, SIS630/730, SIS540, SIS315, SIS315H,
        SIS315PRO/E, SIS550, SIS650/M650/651/740, SIS330(Xabre),
        
SIS660/[M]661[F|M]X/[M]670/[M]741[GX]/[M]760[GX]/[M]761[GX]/[M]770[GX],
        SIS340
(II) SIS: driver for XGI chipsets: Volari Z7 (XG20),
        Volari V3XT/V5/V8/Duo (XG40)
(II) Primary Device is: PCI 00@00:0c:0
(WW) Falling back to old probe method for sis
(--) Assigning device section with no busID to primary device
(--) Chipset SIS6326/AGP/DVD found
(II) Machine type has 8/16 bit access
(II) resource ranges after xf86ClaimFixedResources() call:
(II) resource ranges after probing:
(II) SIS(0): SiS driver (2005/09/20-1, compiled for X.org 1.6.2.0)
(II) SIS(0): Copyright (C) 2001-2005 Thomas Winischhofer 
<thomas@winischhofer.net> and others
(II) SIS(0): *** See http://www.winischhofer.at/linuxsisvga.shtml
(II) SIS(0): *** for documentation and updates.
(--) SIS(0): Chipset is SiS6326 AGP (H0) (revision 0x0b)
(--) SIS(0): Relocated I/O registers at 0x9080
(II) Loading sub module "ramdac"
(II) LoadModule: "ramdac"
(II) Module "ramdac" already built-in
(II) SIS(0): Creating default Display subsection in Screen section
        "Default Screen Section" for depth/fbbpp 24/24
(==) SIS(0): Depth 24, (--) framebuffer bpp 24
(==) SIS(0): RGB weight 888
(==) SIS(0): Default visual is TrueColor
(==) SIS(0): Fast VRAM timing enabled (for read and write)
(==) SIS(0): Using XAA acceleration architecture
(==) SIS(0): Using HW cursor
(==) SIS(0): TurboQueue enabled
(==) SIS(0): DRI disabled
(--) SIS(0): DRAM type: SDRAM/SGRAM
(--) SIS(0): Memory clock: 83.000 MHz
(--) SIS(0): DRAM bus width: 64 bit
(--) SIS(0): Linear framebuffer at 0x9000000
(--) SIS(0): MMIO registers at 0x9A50000 (size 64K)
(--) SIS(0): SiS6326: Detected 8192 KB VideoRAM, limiting to 4096 KB
(II) SIS(0): Using 4032K of framebuffer memory at offset 0K
(--) SIS(0): Hardware supports one video overlay
(==) SIS(0): Using gamma correction (1.0, 1.0, 1.0)
(II) SIS(0): Gamma correction is enabled
(--) SIS(0): Maximum pixel clock at 24 bpp is 154.933 MHz
(II) Loading sub module "ddc"
(II) LoadModule: "ddc"
(II) Module "ddc" already built-in
(II) Loading sub module "vbe"
(II) LoadModule: "vbe"
(II) Loading /usr/lib/xorg/modules//libvbe.so
(II) Module vbe: vendor="X.Org Foundation"
        compiled for 1.6.2, module version = 1.1.0
        ABI class: X.Org Video Driver, version 5.0
(II) Loading sub module "int10"
(II) LoadModule: "int10"
(II) Loading /usr/lib/xorg/modules//libint10.so
(II) Module int10: vendor="X.Org Foundation"
        compiled for 1.6.2, module version = 1.0.0
        ABI class: X.Org Video Driver, version 5.0
(II) SIS(0): initializing int10


Cheers
Michael.

