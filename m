Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYEDIsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYEDIsv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 04:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYEDIso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 04:48:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39602 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbYEDIsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 04:48:43 -0400
Date: Sun, 4 May 2008 10:48:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, Adrian Bunk <bunk@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: warn about complex selects
Message-ID: <20080504084821.GC21859@elte.hu>
References: <20080504054044.GA32030@damson>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080504054044.GA32030@damson>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

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
> (In other words, the number of these has increased significantly since 
> the last release, and these will probably be hit as compile errors at 
> one point or another.)

wow - these are exactly the problems that have been implicated 
statistically via all the build failures.

and this concurs with my observation about build failures in this cycle 
- 2.6.26 showed a sharp rise in Kconfig space build problems. (and i've 
been doing random build tests for a long time)

so your patch is pure gold. A thirty-line quick hack like this if 
implemented years ago could have avoided dozens and dozens of build 
failures and anguish to users, and we'd have lots less trivial patches 
littering the commit logs (and wasting maintainer and review bandwidth) 
as well. (because maintainers could act on these messages right when 
they introduce the select complexity, avoiding such bugs right at their 
source.)

	Ingo
