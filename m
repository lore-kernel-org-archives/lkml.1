Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbYKKIut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbYKKIut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbYKKIul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:50:41 -0500
Received: from gir.skynet.ie ([193.1.99.77]:45590 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbYKKIul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:50:41 -0500
Date: Tue, 11 Nov 2008 08:50:39 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Andrew Morton <akpm@linux-foundation.org>
cc: arrow.ebd@gmail.com, linux_kernel <linux-kernel@vger.kernel.org>
Subject: Re: thinkpad x200 X.server not work with gm4500 graphics
In-Reply-To: <20081111004643.8f8608a3.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.0.82.0811110849250.2182@skynet.skynet.ie>
References: <20081110152518.GA3545@think>
 <20081111004643.8f8608a3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008, Andrew Morton wrote:

> On Mon, 10 Nov 2008 23:25:18 +0800 arrow.ebd@gmail.com wrote:
> 
> > deal,
> > 
> >     My thinkpad x200's X.server can not startup on the kernel 2.6.28,
> 
> Were any earlier kernels OK?  If so, which version(s)?

What userspace Intel X driver is in use? afaik the GM45 wasn't supported 
until after we fixed this issue. Hacking around the size in the kernel 
won't actually fix the problem it actually makes a lot of things a lot 
worse.

Dave.

 > > Thanks.
> 
> > and dmesg will show as below:
> >     -->>--
> >     [drm] Initialized drm 1.1.0 20060810
> >     pci 0000:00:02.0: power state changed by ACPI to D0
> >     pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> >     pci 0000:00:02.0: setting latency timer to 64
> >     [drm] Initialized i915 1.6.0 20060119 on minor 0
> >     pci 0000:00:02.0: pg_start == 0x00001f7f, intel_private.gtt_entries == 0x00001fff
> >     pci 0000:00:02.0: trying to insert into local/stolen memory
> >     --<<--
> > 
> >     Then, I change file "drivers/char/agp/intel-agp.c" as this:
> >     -->>--
> >     --diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
> >     index 9cf6e9b..e681f75 100644
> >     --- a/drivers/char/agp/intel-agp.c
> >     +++ b/drivers/char/agp/intel-agp.c
> >     @@ -528,7 +528,8 @@ static void intel_i830_init_gtt_entries(void)
> >                      * stolen, ignore it in stolen gtt entries counting.  However,
> >                      * 4KB of the stolen memory doesn't get mapped to the GTT.
> >                      */
> >     -               size = 4;
> >     +               /* size = 4; */
> >     +               size = 516;
> >             } else {
> >                     /* On previous hardware, the GTT size was just what was
> >                      * required to map the aperture.
> >     --<<--
> > 
> >     And Xorg can start now.
> > (1) Is it correct ?
> >     Because older kernel use size as "512 + 4" at here, but now use "size = 4".
> > (2) How to deal with it if the patch is not right ?
> > (3) How to get more specification about gm4500 ?
> 
> 
