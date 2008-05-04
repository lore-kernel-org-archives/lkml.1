Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYEDIVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYEDIVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 04:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYEDIVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 04:21:15 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41136 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbYEDIVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 04:21:13 -0400
Date: Sun, 4 May 2008 10:21:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Roman Zippel <zippel@linux-m68k.org>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: warn about complex selects
Message-ID: <20080504082147.GA17276@uranus.ravnborg.org>
References: <20080504054044.GA32030@damson>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080504054044.GA32030@damson>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 07:40:44AM +0200, Vegard Nossum wrote:
> Hi,
> 
> Given recent discussion about kconfig and the "select" feature, I have made
> the following quick & dirty patch to detect what I call "complex selects".
> 
> For v2.6.25, I get these warnings:
> sound/pci/Kconfig:512:error: found complex select: SND_FM801_TEA575X -> VIDEO_V4L1
> drivers/ide/Kconfig:890:error: found complex select: ETRAX_IDE -> BLK_DEV_IDEDMA
> drivers/acpi/Kconfig:185:error: found complex select: ACPI_HOTPLUG_CPU -> ACPI_CONTAINER
> 
> While for v2.6.26-rc1, I get these:
> sound/pci/Kconfig:528:error: found complex select: SND_FM801_TEA575X -> VIDEO_V4L1
> drivers/media/video/em28xx/Kconfig:2:error: found complex select: VIDEO_EM28XX -> MEDIA_TUNER
> drivers/media/video/bt8xx/Kconfig:2:error: found complex select: VIDEO_BT848 -> MEDIA_TUNER
> drivers/media/video/saa7134/Kconfig:2:error: found complex select: VIDEO_SAA7134 -> MEDIA_TUNER
> drivers/media/video/cx88/Kconfig:2:error: found complex select: VIDEO_CX88 -> MEDIA_TUNER
> drivers/media/video/cx23885/Kconfig:2:error: found complex select: VIDEO_CX23885 -> MEDIA_TUNER
> drivers/media/video/ivtv/Kconfig:2:error: found complex select: VIDEO_IVTV -> MEDIA_TUNER
> drivers/media/video/cx18/Kconfig:2:error: found complex select: VIDEO_CX18 -> MEDIA_TUNER
> drivers/media/video/pvrusb2/Kconfig:2:error: found complex select: VIDEO_PVRUSB2 -> MEDIA_TUNER
> drivers/media/video/Kconfig:690:error: found complex select: VIDEO_MXB -> MEDIA_TUNER
> drivers/media/video/usbvision/Kconfig:2:error: found complex select: VIDEO_USBVISION -> MEDIA_TUNER
> drivers/acpi/Kconfig:188:error: found complex select: ACPI_HOTPLUG_CPU -> ACPI_CONTAINER
> 
> (In other words, the number of these has increased significantly since the
> last release, and these will probably be hit as compile errors at one point
> or another.)
> 
> I am not a kconfig expert, so I might have missed some things. Roman, is this
> even remotely good? I think it's probably a good start anyway.

I did a small test of this using following configuration:
config A
        bool "a"

config B
        bool "b"
        depends on A
        default AA || AAA

config BB
        bool "bb"
        depends on A

config C
        bool "c"
        select B

config CC
        bool "cc"
        select BB


I had expected a warning about complex select for
both C and CC. But only C triggered the warning
due to the complex default value of B.
So we need to work on this a bit more.

But great to see code instead of just talking!

	Sam
