Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbYILKyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbYILKyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 06:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYILKyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 06:54:07 -0400
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:28638 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852AbYILKyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 06:54:06 -0400
From: Frans Pop <elendil@planet.nl>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [Bug 10843] Display artifacts on XOrg logout with PAT kernel and VESA framebuffer
Date: Fri, 12 Sep 2008 12:54:01 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <200806231439.00899.elendil@planet.nl> <20080624232252.GA24620@linux-os.sc.intel.com>
In-Reply-To: <20080624232252.GA24620@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121254.02307.elendil@planet.nl>
X-OriginalArrivalTime: 12 Sep 2008 10:54:02.0923 (UTC) FILETIME=[DE67D7B0:01C914C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug-Entry  : http://bugzilla.kernel.org/show_bug.cgi?id=10843

On Wednesday 25 June 2008, Suresh Siddha wrote:
> On Mon, Jun 23, 2008 at 05:38:59AM -0700, Frans Pop wrote:
> > On Sunday 15 June 2008, Siddha, Suresh B wrote:
> > > Frans, With or without pat, in the recent kernels (like
> > > 2.6.26-rc4/rc5 etc), ioremap() uses  UC- and PCI mmap of
> > > /sys/devices/pci.../resource (used by X) uses UC-
> > >
> > > And fb_mmap() also uses UC-.
> > >
> > > It's interesting that you don't see this artifact with "nopat".
> > > Essentially with or with out pat enabled, we use the same memory
> > > attributes. So depending on the MTRR setup (set by X server),
> > > effective memory attribute across different mappings should be same
> > > (which is UC- or WC with mtrr).
> >
> > Any progress on this issue? It's still there with -rc7, but I doubt
> > that comes as a surprise.
> >
> > Has anyone tried to reproduce this? I would think that should be
> > trivial.
> >
> > Just as a summary:
> > - Intel 82945G/GZ graphics [8086:2772] (ICH7 based system)
> > - FB_VESA=y, FRAMEBUFFER_CONSOLE=y
> > - boot with vga=791
> > - Log in to X and KDE; I do need to really log in there are no
> >   artifacts if I exit X from the kdm login dialog
> > - artifacts show on logout
> >
>
> FJP, We will try to reproduce this and getback.

Hello all,

I'd like to bring this issue to your attention once again as it is still 
present in 2.6.27-rc6.

Note also that I can trivially reproduce exactly the same behavior on 
three rather different systems. The artifacts even look similar and in 
all cases they disappear with 'nopat'.

The systems are:
Toshiba Satellite A40 laptop:
- Intel 82852/855GM Integrated Graphics Device [8086:3582]
- ICH4 based
- Mobile Intel Pentium 4 processor, i386 kernel
Intel desktop system:
- Intel 82945G/GZ Integrated Graphics Controller [8086:2772]
- ICH7 based
- Pentium D processor, x86_64 kernel
HP Compaq 2510p laptop:
- Intel Mobile GM965/GL960 Integrated Graphics Controller [8086:2a02]
- ICH8 based
- Core2 Duo processor, x86_64 kernel

Have you had any luck reproducing it?

> Your earlier responses did not give many clues.

Well, unfortunately I can only provide the info you ask for :-)

Cheers,
FJP
