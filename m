Return-Path: <linux-kernel-owner+w=401wt.eu-S1751904AbZI1GL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbZI1GL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 02:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZI1GLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 02:11:55 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:55660
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZI1GLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 02:11:55 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [Qemu-devel] 2.6.31 kernel built for sh4 doesn't boot under qemu-system-sh4.
Date: Mon, 28 Sep 2009 01:11:54 -0500
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
References: <200909201919.17990.rob@landley.net> <20090925084430.GA14363@linux-sh.org>
In-Reply-To: <20090925084430.GA14363@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909280111.54976.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 September 2009 03:44:30 Paul Mundt wrote:
> On Sun, Sep 20, 2009 at 07:19:17PM -0500, Rob Landley wrote:
> > The 2.6.30 kernel in the system image at
> > http://impactlinux.com/fwl/downloads/binaries/system-image-sh4.tar.bz2
> > boots to a shell prompt under a reasonably current qemu-git snapshot
> > (sometime Tuesday I think).
>
> In the future please make sure to cc the linux-sh@vger.kernel.org list, I
> only stumbled across this by chance.

Will do, thanks.

> > >trapped io 0xc0000000 overrides mmio 0xb4001000
> > >trapped io 0xc0001000 overrides mmio 0xb400080c
>
> Also, you do not want to be using trapped io with qemu, it is only there
> to aid broken hardware, and degrades performance under emulation. Boot
> with the "noiotrap" argument on the kernel command line, documented in
> Documentation/kernel-parameters.txt.

Is _that_ why it's so slow?  Thanks.

> > #
> > # Timer and clock configuration
> > #
> > # CONFIG_SH_TIMER_TMU is not set
> > CONFIG_SH_PCLK_FREQ=60000000
> > CONFIG_SH_CLK_CPG=y
> > CONFIG_SH_CLK_CPG_LEGACY=y
> > # CONFIG_NO_HZ is not set
> > # CONFIG_HIGH_RES_TIMERS is not set
> > CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
>
> And here we can see that the TMU option is unset. Fix this up and
> everything should be fine.

Yup, that did it.

> It's actually quite remarkable how far you
> made it in the boot process without a timer interrupt.

Tickless kernels, gotta love 'em. :)

> I'm running current git with qemu and the kernel without any issue,
> except for the aforementioned libata stuff.

Thank you.

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
