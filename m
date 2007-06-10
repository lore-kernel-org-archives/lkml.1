Return-Path: <linux-kernel-owner+w=401wt.eu-S1762269AbXFJFa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbXFJFa4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 01:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758331AbXFJFat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 01:30:49 -0400
Received: from rwcrmhc14.comcast.net ([204.127.192.84]:59742 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385AbXFJFat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 01:30:49 -0400
Message-ID: <466B8C87.1030404@comcast.net>
Date: Sun, 10 Jun 2007 01:30:47 -0400
From: John Richard Moser <nigelenki@comcast.net>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: =?UTF-8?B?VGhvbWFzIEhlbGxzdHLDtm0=?= <thomas@tungstengraphics.com>,
       linux-kernel@vger.kernel.org
Subject: Re: via_drm bug
References: <466B6ADC.7080908@comcast.net> <21d7e9970706092132g4a342348j3c252b0a865f184b@mail.gmail.com>
In-Reply-To: <21d7e9970706092132g4a342348j3c252b0a865f184b@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Dave Airlie wrote:
> On 6/10/07, John Richard Moser <nigelenki@comcast.net> wrote:
> This has been an on-going issue for.... I don't know how long.  I
> reported it a while ago but it's still in 2.6.22.
> 
> Here's another error log.  Loaded the Via driver in Xorg with kernel
> 2.6.22 on Ubuntu, got the following in dmesg.  The [drm:via_mem_alloc]
> error may be the problem.  This is on a 32-bit kernel.
> 
> 
>> I've cc'ed Thomas to see if he can help out, he knows the via drm ..
> 

I may not be able to contribute much testing soon, as this board is
moving out of this machine and I don't have another to put it into for
the moment.  After that it won't be my problem any more, but it'd still
be nice to have it fixed.

It's been bugging me for a while because it seems to be just a piece of
faulty memory management code (probably a bug in the DMA code), but it
hasn't been fixed in several revisions.  Oh well, I'm sure no one's
really looking, so it's good to bring it up and pull out the latest
debug data to say "Yes this is really still broken" once in a while :)

Interestingly enough, I haven't managed to get it to take down the
system since a while back (it used to hard-freeze the kernel).



>> Dave.
> 
> See also:
> 
> https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-via/+bug/72630
> 
> 
> 
> 
> [264565.164000] [drm] Initialized via 2.11.1 20070202 on minor 0
> [264565.168000] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level,
> low) -> IRQ 21
> [264565.168000] [drm] Initialized via 2.11.1 20070202 on minor 1
> [264565.184000] agpgart: Found an AGP 3.0 compliant device at
> 0000:00:00.0.
> [264565.184000] agpgart: Xorg tried to set rate=x12. Setting to AGP3 x8
> mode.
> [264565.184000] agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x
> mode
> [264565.184000] agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x
> mode
> [264565.192000] [drm:via_mem_alloc] *ERROR* Attempt to allocate from
> uninitialized memory manager.
> [264565.296000] powernow-k8: error - out of sync, fix 0x2 0xa, vid 0x0
> 0x0
> [264565.296000] powernow-k8: ph2 null fid transition 0xa
> [264565.692000] irq 21: nobody cared (try booting with the "irqpoll"
> option)
> [264565.692000]  [<c015bcc4>] __report_bad_irq+0x24/0x80
> [264565.692000]  [<c015bf82>] note_interrupt+0x262/0x2a0
> [264565.692000]  [<c015b1e0>] handle_IRQ_event+0x30/0x60
> [264565.692000]  [<c015c96b>] handle_fasteoi_irq+0xbb/0xf0
> [264565.692000]  [<c0106b1b>] do_IRQ+0x3b/0x70
> [264565.692000]  [<c0118735>] smp_apic_timer_interrupt+0x55/0x80
> [264565.692000]  [<c0102e00>] default_idle+0x0/0x60
> [264565.692000]  [<c0105223>] common_interrupt+0x23/0x30
> [264565.692000]  [<c0102e00>] default_idle+0x0/0x60
> [264565.692000]  [<c011db72>] native_safe_halt+0x2/0x10
> [264565.692000]  [<c0102e3c>] default_idle+0x3c/0x60
> [264565.692000]  [<c0102413>] cpu_idle+0x53/0xe0
> [264565.692000]  [<c03dfa7f>] start_kernel+0x31f/0x3b0
> [264565.692000]  [<c03df1f0>] unknown_bootoption+0x0/0x260
> [264565.692000]  =======================
> [264565.692000] handlers:
> [264565.692000] [<f8eb6480>] (via_driver_irq_handler+0x0/0x1d0 [via])
> [264565.692000] Disabling IRQ #21
> 
> 
> 
> Device:
> 
> 01:00.0 VGA compatible controller: VIA Technologies, Inc. S3 Unichrome
> Pro VGA Adapter (rev 01)
> 
> 
> lshw segment:
> 
>            *-display
>                 description: VGA compatible controller
>                 product: S3 Unichrome Pro VGA Adapter
>                 vendor: VIA Technologies, Inc.
>                 physical id: 0
>                 bus info: pci@01:00.0
>                 version: 01
>                 size: 64MB
>                 width: 32 bits
>                 clock: 66MHz
>                 capabilities: vga bus_master cap_list
>                 configuration: latency=32 mingnt=2
>                 resources: iomemory:e4000000-e7ffffff
> iomemory:e8000000-e8ffffff irq:21
> 
> 
- -
To unsubscribe from this list: send the line "unsubscribe
linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
>>

- --
    We will enslave their women, eat their children and rape their
    cattle!
             -- Bosc, Evil alien overlord from the fifth dimension
LiveCD Creator Poll:  http://ubuntuforums.org/showthread.php?t=435562
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIVAwUBRmuMhQs1xW0HCTEFAQJhQw/8DBaejrNgkrAa+8Rcm6Dh3vFfhImchI8D
LKGmz1SBM3suhlNPl5saEiSKAO+jIFa23dpFk7/ijTrVLNRNm8baLAYl8iLBuXiF
DpPZahWYRcbldIj/8osl3169blpiRY/wGaHb2CL50E6POIMo/OyW3nc1St/N7vst
gItuRKW4WtEZaxA5+tGHsc2T3A3JTB3IDS1fUe8uFjsJG9/ciqKQJc2p+xnqMiLM
M29cdwk7X8uJSidMcqXIUc+q+SfZpYOc2yqhx0wbDmtGwGfDjOwb3YX4a/7Tbxcx
8bloaZF+O6olLR2HGcWM4umWExbfXH3+jGj+GyNfCfV1Hn4/EWjdBWC1x6WAJIf/
lXE3kLIDBG3wd2lQq8Dt9oAntErOYBj208VvW3601b4KxthGJVMrfOQX2qvbFbLp
pQzceSruoMZlZ016+k+RVc2uNEFkFxIN8+7N7qDm4R/8qHaNj4YIieQgi0qOg+5c
B7vRq+WcqkhT9mwRtIVlzdk4VIDMytCYp33LGOcnbUbToXsGuDH16+tbZQ3KU2eM
UJ7J30bz6z+y1ksXMJXYx0WDg5miqg7/3GKcTCLCIDIUC47fJ4Nb1y3CNzenxAkQ
eHyg8wQ8Hlz1AINQxX+/C3zrur72fphrw2soX7RtL5NHnFk7lMwU3jxuG+dDgjAU
SWXhWz4g1Jg=
=oAzL
-----END PGP SIGNATURE-----
