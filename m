Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbYCXG6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbYCXG6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 02:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbYCXG6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 02:58:30 -0400
Received: from mail-07.jhb.wbs.co.za ([196.2.97.4]:36128 "EHLO
	mail-07.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbYCXG61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 02:58:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjQLANbt5kfEAmHGZGdsb2JhbACRChwpS5Qe
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] bttv: Add a radio compat_ioctl file operation.
Date: Mon, 24 Mar 2008 08:58:08 +0200
User-Agent: KMail/1.9.9
Cc: Robert Fitzsimons <robfitz@273k.net>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
References: <200802171036.19619.bonganilinux@mweb.co.za> <200803231525.22278.bonganilinux@mweb.co.za> <20080323105017.38d2107b@gaivota>
In-Reply-To: <20080323105017.38d2107b@gaivota>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_BE15HPGnomh5gK5"
Message-Id: <200803240858.09017.bonganilinux@mweb.co.za>
X-Original-Subject: Re: [PATCH] bttv: Add a radio compat_ioctl file operation.
X-Spam-Score: 0.1 (/)
X-Spam-Score-Int: 1
X-Spam-Report: Spam detection software, running on the system "wbs-smtp-out-03.jhb.wbs.co.za", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	Postmaster for details.
	Content preview:  On Sunday 23 March 2008 15:50:17 Mauro Carvalho Chehab wrote:
	> On Sun, 23 Mar 2008 15:25:22 +0200 > > Bongani Hlope <bonganilinux@mweb.co.za>
	wrote: > > rpm -qa | grep radio > > radio-3.95-7mdv2008.0 > > Hmm... exactly
	the same version I have here. > > > 00:00.0 Host bridge: VIA Technologies,
	Inc. VT8385 [K8T800 AGP] Host > > Bridge (rev 01) 00:01.0 PCI bridge: VIA
	Technologies, Inc. VT8237 PCI > > bridge [K8T800/K8T890 South] 00:11.0 ISA
	bridge: VIA Technologies, Inc. > > VT8237 ISA bridge [KT600/K8T800/K8T890
	South] > > It used to have some issues with VIA and PCI, if you're using
	overlay mode > (this is the default, for xawtv). > [...] 
	Content analysis details:   (0.1 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
	0.1 RDNS_DYNAMIC           Delivered to trusted network by host with
	dynamic-looking rDNS
	-0.0 AWL                    AWL: From: address is in the auto white-list
X-Scan-Signature: 61744d584b12424bc99359bd42a1310a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_BE15HPGnomh5gK5
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 23 March 2008 15:50:17 Mauro Carvalho Chehab wrote:
> On Sun, 23 Mar 2008 15:25:22 +0200
>
> Bongani Hlope <bonganilinux@mweb.co.za> wrote:
> > rpm -qa | grep radio
> > radio-3.95-7mdv2008.0
>
> Hmm... exactly the same version I have here.
>
> > 00:00.0 Host bridge: VIA Technologies, Inc. VT8385 [K8T800 AGP] Host
> > Bridge  (rev 01) 00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI
> > bridge [K8T800/K8T890 South] 00:11.0 ISA bridge: VIA Technologies, Inc.
> > VT8237 ISA bridge [KT600/K8T800/K8T890 South]
>
> It used to have some issues with VIA and PCI, if you're using overlay mode
> (this is the default, for xawtv).
>

xawtv works fine, it's only radio that has a problem since 2.6.25-rc?

> This is due to some issues on buggy VIA bridges, when handling PCI2PCI data
> transfers, used in overlay mode. If a PCI2PCI conflicts with a PCI2MEM
> transfer (or a MEM2PCI), you may suffer data loss.
>
> Are you trying to use radio just after a clean reboot, or are you
> experiencing those troubles after running a video application that might be
> using overlay mode?
>

I'm trying to use radio after a clean reboot, as I said above; xatwv and 
tvtime don't seem to have a problem.

> Could you please send me your .config? I'll try to run the same config as
> you, with the latest -rc.
>

attached

> Cheers,
> Mauro

Oh... 

v4l-info /dev/radio

causes this oops (clean reboot)

BUG: unable to handle kernel NULL pointer dereference at 0000000000000250
IP: [<ffffffff8030fe54>] strlcpy+0x11/0x36
PGD 68650067 PUD 7526f067 PMD 0
Oops: 0000 [1] PREEMPT SMP
CPU 1
Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq 
binfmt_misc loop nls_cp437 vfat fat nls_iso8859_1 ntfs thermal processor fan 
container button pcspkr snd_pcm_oss snd_mixer_oss tuner snd_emu10k1 tea5767 
tda8290 tuner_xc2028 tda9887 tuner_simple snd_rawmidi mt20xx snd_ac97_codec 
tea5761 bttv ac97_bus snd_pcm ir_common snd_seq_device compat_ioctl32 
snd_timer firewire_ohci videodev snd_page_alloc uhci_hcd firewire_core 
ehci_hcd snd_util_mem v4l1_compat v4l2_common snd_hwdep usbcore crc_itu_t 
ide_cd_mod videobuf_dma_sg snd sr_mod ohci1394 videobuf_core btcx_risc 
emu10k1_gp ieee1394 cdrom i2c_viapro tg3 gameport soundcore sg tveeprom evdev
Pid: 4756, comm: v4l-info Tainted: G   M     2.6.25-rc5 #44
RIP: 0010:[<ffffffff8030fe54>]  [<ffffffff8030fe54>] strlcpy+0x11/0x36
RSP: 0018:ffff81006414fcb8  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff81006414fdf8 RCX: ffffffffffffffff
RDX: 0000000000000020 RSI: 0000000000000250 RDI: 0000000000000250
RBP: ffff81006414fcb8 R08: ffff81006414fe08 R09: ffff81006414fdf8
R10: ffff81007d885788 R11: 0000000000000202 R12: ffff81007fbe7800
R13: 0000000080685600 R14: ffff81007e76d800 R15: ffffffff88165110
FS:  00007f00eb5666f0(0000) GS:ffff81007fb6adc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000250 CR3: 000000007686f000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process v4l-info (pid: 4756, threadinfo ffff81006414e000, task 
ffff81007e8da180)
Stack:  ffff81006414fcd8 ffffffff88145d33 ffff81007d885788 ffff81006414fdf8
 ffff81006414fdb8 ffffffff88100e58 ffffffffc008561c ffff81006414fd28
 ffff81006414fd08 ffffffff88149b72 ffff81006414fd58 ffffffff88142ed2
Call Trace:
 [<ffffffff88145d33>] :bttv:radio_querycap+0x39/0x6b
 [<ffffffff88100e58>] :videodev:__video_do_ioctl+0x579/0x2e16
 [<ffffffff88149b72>] ? :bttv:bttv_call_i2c_clients+0x16/0x18
 [<ffffffff88142ed2>] ? :bttv:audio_mux+0x105/0x1b5
 [<ffffffff80260449>] ? filemap_fault+0x1fe/0x371
 [<ffffffff88103a95>] :videodev:video_ioctl2+0x1b8/0x259
 [<ffffffff8026d36b>] ? handle_mm_fault+0x341/0x69b
 [<ffffffff80291252>] vfs_ioctl+0x5e/0x77
 [<ffffffff802914b8>] do_vfs_ioctl+0x24d/0x262
 [<ffffffff8045d881>] ? do_page_fault+0x434/0x7aa
 [<ffffffff8029150f>] sys_ioctl+0x42/0x67
 [<ffffffff8020b32b>] system_call_after_swapgs+0x7b/0x80


Code: 4c 29 c2 48 39 d0 72 04 48 8d 4a ff fc 4c 89 cf 4c 01 c0 f3 a4 c6 07 00 
c9 c3 55 31 c0 48 83 c9 ff fc 49 89 f8 48 89 f7 48 89 e5 <f2> ae 48 85 d2 48 
f7 d1 48 8d 41 ff 74 15 48 39 d0 48 89 c1 72
RIP  [<ffffffff8030fe54>] strlcpy+0x11/0x36
 RSP <ffff81006414fcb8>
CR2: 0000000000000250
---[ end trace 7e58c9e343c88870 ]---

but 

v4l-info /dev/video works fine

### v4l2 device info [/dev/video] ###
general info
    VIDIOC_QUERYCAP
        driver                  : "bttv"
        card                    : "BT878 video (Lifeview FlyVideo "
        bus_info                : "PCI:0000:00:05.0"
        version                 : 0.9.17
        capabilities            : 0x5010015 
[VIDEO_CAPTURE,VIDEO_OVERLAY,VBI_CAPTURE,TUNER,READWRITE,STREAMING]

standards
    VIDIOC_ENUMSTD(0)
        index                   : 0
        id                      : 0xff 
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K]
        name                    : "PAL"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(1)
        index                   : 1
        id                      : 0x100 [PAL_M]
        name                    : "PAL-M"
        frameperiod.numerator   : 1001
        frameperiod.denominator : 30000
        framelines              : 525
    VIDIOC_ENUMSTD(2)
        index                   : 2
        id                      : 0x200 [PAL_N]
        name                    : "PAL-N"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(3)
        index                   : 3
        id                      : 0x400 [PAL_Nc]
        name                    : "PAL-Nc"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(4)
        index                   : 4
        id                      : 0x800 [PAL_60]
        name                    : "PAL-60"
        frameperiod.numerator   : 1001
        frameperiod.denominator : 30000
        framelines              : 525
    VIDIOC_ENUMSTD(5)
        index                   : 5
        id                      : 0xb000 [NTSC_M,NTSC_M_JP,?]
        name                    : "NTSC"
        frameperiod.numerator   : 1001
        frameperiod.denominator : 30000
        framelines              : 525
    VIDIOC_ENUMSTD(6)
        index                   : 6
        id                      : 0xff0000 
[SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
        name                    : "SECAM"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625

inputs
    VIDIOC_ENUMINPUT(0)
        index                   : 0
        name                    : "Television"
        type                    : TUNER
        audioset                : 1
        tuner                   : 0
        std                     : 0xffbfff 
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,?,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
        status                  : 0x102 [NO_SIGNAL,NO_H_LOCK]
    VIDIOC_ENUMINPUT(1)
        index                   : 1
        name                    : "Composite1"
        type                    : CAMERA
        audioset                : 1
        tuner                   : 0
        std                     : 0xffbfff 
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,?,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
        status                  : 0x0 []
    VIDIOC_ENUMINPUT(2)
        index                   : 2
        name                    : "S-Video"
        type                    : CAMERA
        audioset                : 1
        tuner                   : 0
        std                     : 0xffbfff 
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,?,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
        status                  : 0x0 []
    VIDIOC_ENUMINPUT(3)
        index                   : 3
        name                    : "Composite3"
        type                    : CAMERA
        audioset                : 1
        tuner                   : 0
        std                     : 0xffbfff 
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,?,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
        status                  : 0x0 []

tuners
    VIDIOC_G_TUNER(0)
        index                   : 0
        name                    : "Television"
        type                    : ANALOG_TV
        capability              : 0x2 [NORM]
        rangelow                : 704
        rangehigh               : 15328
        rxsubchans              : 0x1 [MONO]
        audmode                 : MONO
        signal                  : 0
        afc                     : 0

video capture
    VIDIOC_ENUM_FMT(0,VIDEO_CAPTURE)
        index                   : 0
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "8 bpp, gray"
        pixelformat             : 0x59455247 [GREY]
    VIDIOC_ENUM_FMT(1,VIDEO_CAPTURE)
        index                   : 1
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "8 bpp, dithered color"
        pixelformat             : 0x34324948 [HI24]
    VIDIOC_ENUM_FMT(2,VIDEO_CAPTURE)
        index                   : 2
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "15 bpp RGB, le"
        pixelformat             : 0x4f424752 [RGBO]
    VIDIOC_ENUM_FMT(3,VIDEO_CAPTURE)
        index                   : 3
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "15 bpp RGB, be"
        pixelformat             : 0x51424752 [RGBQ]
    VIDIOC_ENUM_FMT(4,VIDEO_CAPTURE)
        index                   : 4
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "16 bpp RGB, le"
        pixelformat             : 0x50424752 [RGBP]
    VIDIOC_ENUM_FMT(5,VIDEO_CAPTURE)
        index                   : 5
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "16 bpp RGB, be"
        pixelformat             : 0x52424752 [RGBR]
    VIDIOC_ENUM_FMT(6,VIDEO_CAPTURE)
        index                   : 6
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "24 bpp RGB, le"
        pixelformat             : 0x33524742 [BGR3]
    VIDIOC_ENUM_FMT(7,VIDEO_CAPTURE)
        index                   : 7
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "32 bpp RGB, le"
        pixelformat             : 0x34524742 [BGR4]
    VIDIOC_ENUM_FMT(8,VIDEO_CAPTURE)
        index                   : 8
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "32 bpp RGB, be"
        pixelformat             : 0x34424752 [RGB4]
    VIDIOC_ENUM_FMT(9,VIDEO_CAPTURE)
        index                   : 9
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "4:2:2, packed, YUYV"
        pixelformat             : 0x56595559 [YUYV]
    VIDIOC_ENUM_FMT(10,VIDEO_CAPTURE)
        index                   : 10
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "4:2:2, packed, YUYV"
        pixelformat             : 0x56595559 [YUYV]
    VIDIOC_ENUM_FMT(11,VIDEO_CAPTURE)
        index                   : 11
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "4:2:2, packed, UYVY"
        pixelformat             : 0x59565955 [UYVY]
    VIDIOC_ENUM_FMT(12,VIDEO_CAPTURE)
        index                   : 12
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "4:2:2, planar, Y-Cb-Cr"
        pixelformat             : 0x50323234 [422P]
    VIDIOC_ENUM_FMT(13,VIDEO_CAPTURE)
        index                   : 13
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "4:2:0, planar, Y-Cb-Cr"
        pixelformat             : 0x32315559 [YU12]
    VIDIOC_ENUM_FMT(14,VIDEO_CAPTURE)
        index                   : 14
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "4:2:0, planar, Y-Cr-Cb"
        pixelformat             : 0x32315659 [YV12]
    VIDIOC_ENUM_FMT(15,VIDEO_CAPTURE)
        index                   : 15
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "4:1:1, planar, Y-Cb-Cr"
        pixelformat             : 0x50313134 [411P]
    VIDIOC_ENUM_FMT(16,VIDEO_CAPTURE)
        index                   : 16
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "4:1:0, planar, Y-Cb-Cr"
        pixelformat             : 0x39565559 [YUV9]
    VIDIOC_ENUM_FMT(17,VIDEO_CAPTURE)
        index                   : 17
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "4:1:0, planar, Y-Cr-Cb"
        pixelformat             : 0x39555659 [YVU9]
    VIDIOC_G_FMT(VIDEO_CAPTURE)
        type                    : VIDEO_CAPTURE
        fmt.pix.width           : 320
        fmt.pix.height          : 240
        fmt.pix.pixelformat     : 0x59565955 [UYVY]
        fmt.pix.field           : INTERLACED
        fmt.pix.bytesperline    : 640
        fmt.pix.sizeimage       : 153600
        fmt.pix.colorspace      : unknown
        fmt.pix.priv            : 0

video overlay
    VIDIOC_ENUM_FMT(0,VIDEO_OVERLAY)
        index                   : 0
        type                    : VIDEO_OVERLAY
        flags                   : 0
        description             : "8 bpp, gray"
        pixelformat             : 0x59455247 [GREY]
    VIDIOC_ENUM_FMT(1,VIDEO_OVERLAY)
        index                   : 1
        type                    : VIDEO_OVERLAY
        flags                   : 0
        description             : "8 bpp, dithered color"
        pixelformat             : 0x34324948 [HI24]
    VIDIOC_ENUM_FMT(2,VIDEO_OVERLAY)
        index                   : 2
        type                    : VIDEO_OVERLAY
        flags                   : 0
        description             : "15 bpp RGB, le"
        pixelformat             : 0x4f424752 [RGBO]
    VIDIOC_ENUM_FMT(3,VIDEO_OVERLAY)
        index                   : 3
        type                    : VIDEO_OVERLAY
        flags                   : 0
        description             : "15 bpp RGB, be"
        pixelformat             : 0x51424752 [RGBQ]
    VIDIOC_ENUM_FMT(4,VIDEO_OVERLAY)
        index                   : 4
        type                    : VIDEO_OVERLAY
        flags                   : 0
        description             : "16 bpp RGB, le"
        pixelformat             : 0x50424752 [RGBP]
    VIDIOC_ENUM_FMT(5,VIDEO_OVERLAY)
        index                   : 5
        type                    : VIDEO_OVERLAY
        flags                   : 0
        description             : "16 bpp RGB, be"
        pixelformat             : 0x52424752 [RGBR]
    VIDIOC_ENUM_FMT(6,VIDEO_OVERLAY)
        index                   : 6
        type                    : VIDEO_OVERLAY
        flags                   : 0
        description             : "24 bpp RGB, le"
        pixelformat             : 0x33524742 [BGR3]
    VIDIOC_ENUM_FMT(7,VIDEO_OVERLAY)
        index                   : 7
        type                    : VIDEO_OVERLAY
        flags                   : 0
        description             : "32 bpp RGB, le"
        pixelformat             : 0x34524742 [BGR4]
    VIDIOC_ENUM_FMT(8,VIDEO_OVERLAY)
        index                   : 8
        type                    : VIDEO_OVERLAY
        flags                   : 0
        description             : "32 bpp RGB, be"
        pixelformat             : 0x34424752 [RGB4]
    VIDIOC_ENUM_FMT(9,VIDEO_OVERLAY)
        index                   : 9
        type                    : VIDEO_OVERLAY
        flags                   : 0
        description             : "4:2:2, packed, YUYV"
        pixelformat             : 0x56595559 [YUYV]
    VIDIOC_ENUM_FMT(10,VIDEO_OVERLAY)
        index                   : 10
        type                    : VIDEO_OVERLAY
        flags                   : 0
        description             : "4:2:2, packed, YUYV"
        pixelformat             : 0x56595559 [YUYV]
    VIDIOC_ENUM_FMT(11,VIDEO_OVERLAY)
        index                   : 11
        type                    : VIDEO_OVERLAY
        flags                   : 0
        description             : "4:2:2, packed, UYVY"
        pixelformat             : 0x59565955 [UYVY]
    VIDIOC_G_FMT(VIDEO_OVERLAY)
        type                    : VIDEO_OVERLAY
        fmt.win.w.left          : 0
        fmt.win.w.top           : 0
        fmt.win.w.width         : 320
        fmt.win.w.height        : 240
        fmt.win.field           : ANY
        fmt.win.chromakey       : 0
        fmt.win.clips           : (nil)
        fmt.win.clipcount       : 0
        fmt.win.bitmap          : (nil)
    VIDIOC_G_FBUF
        capability              : 0x4 [LIST_CLIPPING]
        flags                   : 0x0 []
        base                    : (nil)
        fmt.width               : 0
        fmt.height              : 0
        fmt.pixelformat         : 0x59565955 [UYVY]
        fmt.field               : ANY
        fmt.bytesperline        : 0
        fmt.sizeimage           : 0
        fmt.colorspace          : unknown
        fmt.priv                : 0

vbi capture
    VIDIOC_ENUM_FMT(0,VBI_CAPTURE)
        index                   : 0
        type                    : VBI_CAPTURE
        flags                   : 0
        description             : "vbi data"
        pixelformat             : 0x59455247 [GREY]
    VIDIOC_G_FMT(VBI_CAPTURE)
        type                    : VBI_CAPTURE
        fmt.vbi.sampling_rate   : 35468950
        fmt.vbi.offset          : 244
        fmt.vbi.samples_per_line: 2048
        fmt.vbi.sample_format   : 0x59455247 [GREY]
        fmt.vbi.start[0]        : 7
        fmt.vbi.start[1]        : 320
        fmt.vbi.count[0]        : 16
        fmt.vbi.count[1]        : 16
        fmt.vbi.flags           : 0

controls
    VIDIOC_QUERYCTRL(BASE+0)
        id                      : 9963776
        type                    : INTEGER
        name                    : "Brightness"
        minimum                 : 0
        maximum                 : 65535
        step                    : 256
        default_value           : 32768
        flags                   : 0
    VIDIOC_QUERYCTRL(BASE+1)
        id                      : 9963777
        type                    : INTEGER
        name                    : "Contrast"
        minimum                 : 0
        maximum                 : 65535
        step                    : 128
        default_value           : 32768
        flags                   : 0
    VIDIOC_QUERYCTRL(BASE+2)
        id                      : 9963778
        type                    : INTEGER
        name                    : "Saturation"
        minimum                 : 0
        maximum                 : 65535
        step                    : 128
        default_value           : 32768
        flags                   : 0
    VIDIOC_QUERYCTRL(BASE+3)
        id                      : 9963779
        type                    : INTEGER
        name                    : "Hue"
        minimum                 : 0
        maximum                 : 65535
        step                    : 256
        default_value           : 32768
        flags                   : 0
    VIDIOC_QUERYCTRL(BASE+6)
        id                      : 9963782
        type                    : INTEGER
        name                    : "Balance"
        minimum                 : 0
        maximum                 : 65535
        step                    : 655
        default_value           : 32768
        flags                   : 0
    VIDIOC_QUERYCTRL(BASE+7)
        id                      : 9963783
        type                    : INTEGER
        name                    : "Bass"
        minimum                 : 0
        maximum                 : 65535
        step                    : 655
        default_value           : 32768
        flags                   : 0
    VIDIOC_QUERYCTRL(BASE+8)
        id                      : 9963784
        type                    : INTEGER
        name                    : "Treble"
        minimum                 : 0
        maximum                 : 65535
        step                    : 655
        default_value           : 32768
        flags                   : 0
    VIDIOC_QUERYCTRL(BASE+9)
        id                      : 9963785
        type                    : BOOLEAN
        name                    : "Mute"
        minimum                 : 0
        maximum                 : 1
        step                    : 0
        default_value           : 0
        flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+0)
        id                      : 134217728
        type                    : BOOLEAN
        name                    : "chroma agc"
        minimum                 : 0
        maximum                 : 1
        step                    : 0
        default_value           : 0
        flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+1)
        id                      : 134217729
        type                    : BOOLEAN
        name                    : "combfilter"
        minimum                 : 0
        maximum                 : 1
        step                    : 0
        default_value           : 0
        flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+2)
        id                      : 134217730
        type                    : BOOLEAN
        name                    : "automute"
        minimum                 : 0
        maximum                 : 1
        step                    : 0
        default_value           : 0
        flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+3)
        id                      : 134217731
        type                    : BOOLEAN
        name                    : "luma decimation filter"
        minimum                 : 0
        maximum                 : 1
        step                    : 0
        default_value           : 0
        flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+4)
        id                      : 134217732
        type                    : BOOLEAN
        name                    : "agc crush"
        minimum                 : 0
        maximum                 : 1
        step                    : 0
        default_value           : 0
        flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+5)
        id                      : 134217733
        type                    : BOOLEAN
        name                    : "vcr hack"
        minimum                 : 0
        maximum                 : 1
        step                    : 0
        default_value           : 0
        flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+6)
        id                      : 134217734
        type                    : INTEGER
        name                    : "whitecrush upper"
        minimum                 : 0
        maximum                 : 255
        step                    : 1
        default_value           : 207
        flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+7)
        id                      : 134217735
        type                    : INTEGER
        name                    : "whitecrush lower"
        minimum                 : 0
        maximum                 : 255
        step                    : 1
        default_value           : 127
        flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+8)
        id                      : 134217736
        type                    : INTEGER
        name                    : "uv ratio"
        minimum                 : 0
        maximum                 : 100
        step                    : 1
        default_value           : 50
        flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+9)
        id                      : 134217737
        type                    : BOOLEAN
        name                    : "full luma range"
        minimum                 : 0
        maximum                 : 1
        step                    : 0
        default_value           : 0
        flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+10)
        id                      : 134217738
        type                    : INTEGER
        name                    : "coring"
        minimum                 : 0
        maximum                 : 3
        step                    : 1
        default_value           : 0
        flags                   : 0

### video4linux device info [/dev/video] ###
general info
    VIDIOCGCAP
        name                    : "BT878 video (Lifeview FlyVideo "
        type                    : 0x2f 
[CAPTURE,TUNER,TELETEXT,OVERLAY,CLIPPING]
        channels                : 4
        audios                  : 0
        maxwidth                : 924
        maxheight               : 576
        minwidth                : 48
        minheight               : 32

channels
    VIDIOCGCHAN(0)
        channel                 : 0
        name                    : "Television"
        tuners                  : 1
        flags                   : 0x1 [TUNER]
        type                    : TV
        norm                    : 0
    VIDIOCGCHAN(1)
        channel                 : 1
        name                    : "Composite1"
        tuners                  : 0
        flags                   : 0x0 []
        type                    : CAMERA
        norm                    : 0
    VIDIOCGCHAN(2)
        channel                 : 2
        name                    : "S-Video"
        tuners                  : 0
        flags                   : 0x0 []
        type                    : CAMERA
        norm                    : 0
    VIDIOCGCHAN(3)
        channel                 : 3
        name                    : "Composite3"
        tuners                  : 0
        flags                   : 0x0 []
        type                    : CAMERA
        norm                    : 0

tuner
    VIDIOCGTUNER
        tuner                   : 0
        name                    : "Television"
        rangelow                : 0
        rangehigh               : 704
        flags                   : 0x0 []
        mode                    : unknown
        signal                  : 0

audio
    VIDIOCGAUDIO
        audio                   : 0
        volume                  : 0
        bass                    : 0
        treble                  : 0

picture
    VIDIOCGPICT
        brightness              : 32768
        hue                     : 32768
        colour                  : 32768
        contrast                : 32768
        whiteness               : 0
        depth                   : 16
        palette                 : UYVY

buffer
    VIDIOCGFBUF
        base                    : (nil)
        height                  : 0
        width                   : 0
        depth                   : 0
        bytesperline            : 0

window
    VIDIOCGWIN
        x                       : 0
        y                       : 0
        width                   : 320
        height                  : 240
        chromakey               : 0
        flags                   : 0


--Boundary-00=_BE15HPGnomh5gK5
Content-Type: application/x-gzip;
  name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="config.gz"

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
2TF/ipLV84YOH2h2cYGEXFH2cN+i0gl+br8gAA==

--Boundary-00=_BE15HPGnomh5gK5--
