Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbXLLNnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbXLLNnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 08:43:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbXLLNmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 08:42:47 -0500
Received: from host06.hostingexpert.com ([216.80.70.60]:37083 "EHLO
	host06.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbXLLNmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 08:42:46 -0500
Message-ID: <475FE553.4020702@linuxtv.org>
Date: Wed, 12 Dec 2007 08:42:43 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
CC: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com
Subject: Re: [v4l-dvb-maintainer] build #340 failed for 2.6.24-rc5-g75b8c13
 in	linux/drivers/media/video/tuner.ko
References: <200712120934.46156.toralf.foerster@gmx.de>
In-Reply-To: <200712120934.46156.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host06.hostingexpert.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxtv.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toralf Förster wrote:
> Hello,
>
> the build with the attached .config failed, make ends with:
> ...
>   GZIP    arch/x86/boot/compressed/vmlinux.bin.gz
>   LD      arch/x86/boot/compressed/piggy.o
>   LD      arch/x86/boot/compressed/vmlinux
>   OBJCOPY arch/x86/boot/vmlinux.bin
>   HOSTCC  arch/x86/boot/tools/build
>   BUILD   arch/x86/boot/bzImage
> Root device is (3, 8)
> Setup is 11320 bytes (padded to 11776 bytes).
> System is 1848 kB
> Kernel: arch/x86/boot/bzImage is ready  (#1)
>   Building modules, stage 2.
>   MODPOST 352 modules
> ERROR: "tea5761_attach" [drivers/media/video/tuner.ko] undefined!
> ERROR: "tea5761_autodetection" [drivers/media/video/tuner.ko] undefined!
> ERROR: "tea5767_autodetection" [drivers/media/video/tuner.ko] undefined!
> ERROR: "tea5767_attach" [drivers/media/video/tuner.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
>
> The build was made with an old .config from kernel 2.6.24-rc2
> (where the build also failed) :
> $> make mrproper && cp <oldconfig> .config && make oldconfig && make
>
> Here's the config:
>
> [snip]
>
> CONFIG_VIDEO_TUNER=m
> CONFIG_VIDEO_TUNER_CUSTOMIZE=y
> # CONFIG_TUNER_MT20XX is not set
> CONFIG_TUNER_TDA8290=m
> CONFIG_TUNER_TEA5761=y
> CONFIG_TUNER_TEA5767=y
> CONFIG_TUNER_SIMPLE=m
>   
Toralf,

It looks like the problem has something to do with VIDEO_TUNER=m while
both TUNER_TEA5761 & TUNER_TEA5767 are set to 'y'.

I thought that we had already seen this issue and fixed it, but I guess
not :-/

One would think that this could be fixed by making TUNER_TEA5761 &
TUNER_TEA5767 both depend on VIDEO_TUNER , but that would be wrong,
since each of those modules can be attached directly to a bridge driver
without tuner.ko being present at all (although this is not done in
practice right now, but it *is* the case with some other tuner drivers)

I'm going to have to think about this for a bit and do some
experimentation.  Thanks for reporting.

Regards,

Mike
