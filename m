Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab0BKROw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 12:14:52 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:44691 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab0BKROu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:14:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f7Hl5gZVfca9wwKRyJ/aDV5vPlaAZcjvOvlG3dE7RtCF0VON1NTfSvIA+uU/ZzWkwG
         htzsvkNaoBA5NqYSqWo11vWzrtjA93GbjKEEndK0FoCryQU0CU3W/a43ExX6w8WiFoYr
         +lxW6GdZW88RasUGAR3FaecoxylLthXZYRpVM=
Date: Thu, 11 Feb 2010 18:15:13 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Lam <lambchop468@gmail.com>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: mtrr cleanup not doing anything on 2.6.33-rc7
Message-ID: <20100211171513.GA6700@Pilar.aei.mpg.de>
References: <dfb03c971002101202i37f4a243jc6bfb44bc853cb5d@mail.gmail.com>
 <dfb03c971002101748i39d7de0bw83634c40f058de0f@mail.gmail.com>
 <20100211101013.GA4892@Pilar.aei.mpg.de>
 <4B741ABB.2000600@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B741ABB.2000600@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Do 11.Feb'10 at  6:56:59 -0800, H. Peter Anvin wrote:
> On 02/11/2010 02:10 AM, Carlos R. Mafra wrote:
> > [Add people in that commit to Cc: list, just in case]
> > 
> > On Mi 10.Feb'10 at 20:48:49 -0500, Alexander Lam wrote:
> >> On Wed, Feb 10, 2010 at 3:02 PM, Alexander Lam <lambchop468@gmail.com> wrote:
> >>>
> >>> My kernel config has the following:
> >>> CONFIG_MTRR=y
> >>> CONFIG_MTRR_SANITIZER=y
> >>> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> >>> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> >>>
> >>> With previous kernels, dmesg would show that the sanitizer was indeed
> >>> cleaning up the mtrrs [1]
> >>>
> >>> but now, with 2.6.33-rc7 there is no indication that this is occuring,
> >>
> >> For those who run across this later,
> >>
> >> Found out that commit 508d85c2c6bc8cba53d2a54d9a306ad64a0a80bf,
> >>    x86: When cleaning MTRRs, do not fold WP into UC
> >>
> >> causes mtrr cleanup not to run on my machine.
> >>
> >> Probably not worth fixing because the i915 error message is harmless.
> >> --
> 
> You're not stating what your MTRR setup looks like, and hence if there
> is anything to clean up.

I am not sure if I am being an intruder here, but I also should
have quoted Alexander's first email:

Hi all,

Please CC: me when replying.

My kernel config has the following:
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1

With previous kernels, dmesg would show that the sanitizer was indeed
cleaning up the mtrrs [1]

but now, with 2.6.33-rc7 there is no indication that this is occuring,
and the intel i915 driver complains:
   [    0.613419] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
   [    0.614577] i915 0000:00:02.0: setting latency timer to 64
   [    0.625446] mtrr: no more MTRRs available
   [    0.625529] [drm] MTRR allocation failed.  Graphics performance
may suffer.

What has changed and what do I need to do to make the mtrr sanitation
work again?

[1]: dmesg from previous kernels:
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFFE0000 mask 0FFFE0000 write-protect
[    0.000000]   1 base 0FFFC0000 mask 0FFFE0000 uncachable
[    0.000000]   2 base 000000000 mask 0E0000000 write-back
[    0.000000]   3 base 020000000 mask 0E0000000 write-back
[    0.000000]   4 base 03F800000 mask 0FF800000 uncachable
[    0.000000]   5 base 03F600000 mask 0FFE00000 uncachable
[    0.000000]   6 base 03F500000 mask 0FFF00000 uncachable
[    0.000000]   7 base 000000000 mask 0FFFE0000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 4194176KB, range: 128KB, type WP
[    0.000000] reg 1, base: 4194048KB, range: 128KB, type UC
[    0.000000] reg 2, base: 0GB, range: 512MB, type WB
[    0.000000] reg 3, base: 512MB, range: 512MB, type WB
[    0.000000] reg 4, base: 1016MB, range: 8MB, type UC
[    0.000000] reg 5, base: 1014MB, range: 2MB, type UC
[    0.000000] reg 6, base: 1013MB, range: 1MB, type UC
[    0.000000] reg 7, base: 0GB, range: 128KB, type UC
[    0.000000] WARNING: BIOS bug: VAR MTRR 7 contains strange UC entry
under 1M, check with your system vendor!
[    0.000000] total RAM coverred: 1013M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K  chunk_size: 16M         num_reg: 4
 lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 1GB, type WB
[    0.000000] reg 1, base: 1013MB, range: 1MB, type UC
[    0.000000] reg 2, base: 1014MB, range: 2MB, type UC
[    0.000000] reg 3, base: 1016MB, range: 8MB, type UC
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106


Thanks,
-- 
Alexander Lam

