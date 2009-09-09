Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbZIIHJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbZIIHJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 03:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZIIHJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 03:09:32 -0400
Received: from mailout03.t-online.de ([194.25.134.81]:44700 "EHLO
	mailout03.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZIIHJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 03:09:32 -0400
Message-ID: <4AA7549B.5040905@t-online.de>
Date: Wed, 09 Sep 2009 09:09:15 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Thunderbird 1.5.0.14 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: airlied@linux.ie, linux-kernel@vger.kernel.org,
       ykzhao <yakui.zhao@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Regression DRM/i915/KMS: VGA connector unusable after 2.6.31-rc8-git1,
 DVI connector ok
References: <4AA6D858.6040505@t-online.de> <alpine.LFD.2.01.0909081607400.7458@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0909081607400.7458@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-ID: EwzOocZbQhHny6gJDCOkmG2AivS1n6LB-YljKy0L+wQ2lVbIX5kbywUT7KBzNt6gQU
X-TOI-MSGID: 199b938f-07bd-464d-8e4e-52f53de0bcf6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I just pushed out something that may fix it. It was reported to fix 
> another situation that sounds _somewhat_ similar (ie VGA out on a mobile 
> chipset)
>
> It's commit 7c8460d: "drm/i915: fix mask bits setting", but it may take a 
> few minutes to mirror out to the public machines, so if you don't see it 
> yet, here's the patch if you want to try.
>
> 			Linus
>   
Zhenyu Wangs patch fixed the problem, and 2.6.31-rc9-git2 works again with
monitors attached to the VGA output. Thanks to all of you for the quick
reaction.

BTW: My reason to try kernel 2.6.31-* is to find a good replacement for
my current
outdated setup (kernel 2.6.22.6 with a vintage (2006) X Window System
Version 7.1.99.902).
I´m testing the current kernels and X.Org X Server 1.6.3, Release Date:
2009-7-31, with
intel module version = 2.8.0. (openSuSE 11.2 MS 6).

The old setup is a bit faster, and glx acceleration is much smoother:

- glxgears running on the old setup looks fine running on
  the old software, no matter what window size is used.

- glxgears running on the new setup looks almost fine with small
  windows, but is _very_ jerky running in a big window.

As the old X does not work with the new kernel, I cannot decide if the
kernel
or X is to blame.

Some other things I noticed. Have a look at the log:

<6>[    1.933807] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
<6>[    1.934571] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
<6>[    1.937271] agpgart-intel 0000:00:00.0: AGP aperture is 256M @
0xc0000000
<6>[    1.937431] [drm] Initialized drm 1.1.0 20060810
<6>[    1.937528] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
<7>[    1.937619] i915 0000:00:02.0: setting latency timer to 64
<6>[    3.051634] [drm] TV-12: set mode NTSC 480i 0
<3>[    3.271424] render error detected, EIR: 0x00000010
<3>[    3.271426] page table error
<3>[    3.271428]   PGTBL_ER: 0x00000010
<3>[    3.271431] [drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010,
masking
<3>[    3.271437] render error detected, EIR: 0x00000010
<3>[    3.271438] page table error
<3>[    3.271440]   PGTBL_ER: 0x00000010
<6>[    3.277774] [drm] DAC-6: set mode 1280x1024 2c
<6>[    3.375806] [drm] TMDS-8: set mode 1280x1024 2d
<4>[    3.632583] Console: switching to colour frame buffer device 160x64
<6>[    3.638966] [drm] fb0: inteldrmfb frame buffer device
<6>[    3.639011] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0
on minor 0

What shall I think about that render error followed by "EIR stuck"?
Apparently it does not hurt, but it does appear on every boot.

What´s about that page table error? It´s also in every boot log,
and it seems that it does not hurt either.

In the boot log I  read "TV-12: set mode NTSC 480i 0". Well, I do
not use the TV out connector, but in the BIOS setup I selected
PAL and not NTSC. Why isn´t that detected and used?

cu,
 Knut


