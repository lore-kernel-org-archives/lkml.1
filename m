Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658AbZIIQEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbZIIQEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 12:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZIIQEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 12:04:22 -0400
Received: from outbound-mail-120.bluehost.com ([69.89.18.6]:45661 "HELO
	outbound-mail-120.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753307AbZIIQEV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:04:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=iKTr6x98sqGulPKrEorE55rOWnU49EyT1MkzcC5ghXuhcovg18nLb/5ukutqgP4RzWI6PDwyNLUep9mht01SNUQ7d9QSDgjBGmbwQa4FOvD1NwpYPw3N1wfSqWixlgHo;
Date: Wed, 9 Sep 2009 09:04:21 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, airlied@linux.ie,
       linux-kernel@vger.kernel.org, ykzhao <yakui.zhao@intel.com>
Subject: Re: Regression DRM/i915/KMS: VGA connector unusable after
 2.6.31-rc8-git1, DVI connector ok
Message-ID: <20090909090421.41a72b8d@jbarnes-g45>
In-Reply-To: <4AA7549B.5040905@t-online.de>
References: <4AA6D858.6040505@t-online.de>
	<alpine.LFD.2.01.0909081607400.7458@localhost.localdomain>
	<4AA7549B.5040905@t-online.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Sep 2009 09:09:15 +0200
Knut Petersen <Knut_Petersen@t-online.de> wrote:

> 
> > I just pushed out something that may fix it. It was reported to fix 
> > another situation that sounds _somewhat_ similar (ie VGA out on a
> > mobile chipset)
> >
> > It's commit 7c8460d: "drm/i915: fix mask bits setting", but it may
> > take a few minutes to mirror out to the public machines, so if you
> > don't see it yet, here's the patch if you want to try.
> >
> > 			Linus
> >   
> Zhenyu Wangs patch fixed the problem, and 2.6.31-rc9-git2 works again
> with monitors attached to the VGA output. Thanks to all of you for
> the quick reaction.
> 
> BTW: My reason to try kernel 2.6.31-* is to find a good replacement
> for my current
> outdated setup (kernel 2.6.22.6 with a vintage (2006) X Window System
> Version 7.1.99.902).
> I´m testing the current kernels and X.Org X Server 1.6.3, Release
> Date: 2009-7-31, with
> intel module version = 2.8.0. (openSuSE 11.2 MS 6).
> 
> The old setup is a bit faster, and glx acceleration is much smoother:
> 
> - glxgears running on the old setup looks fine running on
>   the old software, no matter what window size is used.
> 
> - glxgears running on the new setup looks almost fine with small
>   windows, but is _very_ jerky running in a big window.
> 
> As the old X does not work with the new kernel, I cannot decide if the
> kernel
> or X is to blame.
> 
> Some other things I noticed. Have a look at the log:
> 
> <6>[    1.933807] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
> <6>[    1.934571] agpgart-intel 0000:00:00.0: detected 7932K stolen
> memory <6>[    1.937271] agpgart-intel 0000:00:00.0: AGP aperture is
> 256M @ 0xc0000000
> <6>[    1.937431] [drm] Initialized drm 1.1.0 20060810
> <6>[    1.937528] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low)
> -> IRQ 16
> <7>[    1.937619] i915 0000:00:02.0: setting latency timer to 64
> <6>[    3.051634] [drm] TV-12: set mode NTSC 480i 0
> <3>[    3.271424] render error detected, EIR: 0x00000010
> <3>[    3.271426] page table error
> <3>[    3.271428]   PGTBL_ER: 0x00000010
> <3>[    3.271431] [drm:i915_handle_error] *ERROR* EIR stuck:
> 0x00000010, masking
> <3>[    3.271437] render error detected, EIR: 0x00000010
> <3>[    3.271438] page table error
> <3>[    3.271440]   PGTBL_ER: 0x00000010
> <6>[    3.277774] [drm] DAC-6: set mode 1280x1024 2c
> <6>[    3.375806] [drm] TMDS-8: set mode 1280x1024 2d
> <4>[    3.632583] Console: switching to colour frame buffer device
> 160x64 <6>[    3.638966] [drm] fb0: inteldrmfb frame buffer device
> <6>[    3.639011] [drm] Initialized i915 1.6.0 20080730 for
> 0000:00:02.0 on minor 0

Linus is probably right here; old X assumes it completely owns the
hardware, so won't work very well if you have a KMS enabled i915
driver.  Loading i915 with modeset=0 should let you use the old
interfaces.

> What shall I think about that render error followed by "EIR stuck"?
> Apparently it does not hurt, but it does appear on every boot.
> 
> What´s about that page table error? It´s also in every boot log,
> and it seems that it does not hurt either.

These two are related.  The BIOS is probably setting up a partially
bogus configuration.  Then when the i915 driver initializes we see the
errors.  We might be able to work around it by doing some extra
hardware work (disabling everything or scanning for bad addresses), but
I haven't had time to try that out yet.

> In the boot log I  read "TV-12: set mode NTSC 480i 0". Well, I do
> not use the TV out connector, but in the BIOS setup I selected
> PAL and not NTSC. Why isn´t that detected and used?

You'll see lines like that whenever the kernel does load detection on
an output.  In this case it's trying to set a mode on the TV output
(which is always there, even if you don't have an exposed connector) to
see if anything is attached.  For load detection purposes I don't think
it matters if we use PAL or NTSC signaling; but please file a bug at
bugs.freedesktop.org if you find problems (see
http://www.intellinuxgraphics.org/how_to_report_bug.html for the sort
of info we're looking for).

-- 
Jesse Barnes, Intel Open Source Technology Center
