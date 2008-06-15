Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbYFOXCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbYFOXCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 19:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYFOXCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 19:02:15 -0400
Received: from cpsmtpo-eml01.kpnxchange.com ([213.75.38.150]:29847 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbYFOXCP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 19:02:15 -0400
From: Frans Pop <elendil@planet.nl>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [Bug 10843] Display artifacts on XOrg logout with PAT kernel and VESA framebuffer
Date: Mon, 16 Jun 2008 01:02:10 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <200806142359.36613.elendil@planet.nl> <8B23168BCBB43B49A4C8EAB32D4B62F1061F3A82@orsmsx505.amr.corp.intel.com>
In-Reply-To: <8B23168BCBB43B49A4C8EAB32D4B62F1061F3A82@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <200806160102.11717.elendil@planet.nl>
X-OriginalArrivalTime: 15 Jun 2008 23:02:12.0324 (UTC) FILETIME=[D88DA240:01C8CF3B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 June 2008, Siddha, Suresh B wrote:
> > Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=10843
> > Subject       : Display artifacts on XOrg logout with PAT kernel
> > and VESA framebuffer
> > Submitter     : Frans Pop <elendil@planet.nl>
> > Date          : 2008-05-31 14:04 (15 days old)
> > References    : http://lkml.org/lkml/2008/6/7/206
>
> Can you also check, if there is any impact with kernel boot param for
> vesafb "mtrr:3"?

Hello Suresh. Thanks for responding.

I've done 4 successive boots with the boot parameters as shown below.
Each boot was basically: set correct parameters in grub -> login to KDE
                         -> reboot and check for artifacts.

1) (none)                      --> clean
2) vga=791                     --> artifacts
3) vga=791 nopat               --> clean
4) vga=791 video=vesafb:mtrr:3 --> artifacts

So the mtrr option did not help (if I passed it correctly; the double ":"
is somewhat non-intuitive). The kernel log also does not show any
difference I can see in the last boot, but I don't know if the mtrr option
is supposed to show up in any way.

>From the kernel log for each boot:
1) x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
   Console: colour VGA+ 80x25
   console [tty0] enabled

2) x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
   Console: colour dummy device 80x25
   console [tty0] enabled
   vesafb: framebuffer at 0x80000000, mapped to 0xffffc20000900000, using 3072k, total 7872k
   vesafb: mode is 1024x768x16, linelength=2048, pages=4
   vesafb: scrolling: redraw
   vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
   Console: switching to colour frame buffer device 128x48
   fb0: VESA VGA frame buffer device

3) PAT support disabled
   Console: colour dummy device 80x25
   console [tty0] enabled
   vesafb: framebuffer at 0x80000000, mapped to 0xffffc20000900000, using 3072k, total 7872k
   vesafb: mode is 1024x768x16, linelength=2048, pages=4
   vesafb: scrolling: redraw
   vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
   Console: switching to colour frame buffer device 128x48
   fb0: VESA VGA frame buffer device

4) x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
   Console: colour dummy device 80x25
   console [tty0] enabled
   vesafb: framebuffer at 0x80000000, mapped to 0xffffc20000900000, using 3072k, total 7872k
   vesafb: mode is 1024x768x16, linelength=2048, pages=4
   vesafb: scrolling: redraw
   vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
   Console: switching to colour frame buffer device 128x48
   fb0: VESA VGA frame buffer device

Hope that helps. If you need any additional information, please ask.

Cheers,
FJP
