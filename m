Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbYKMPXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbYKMPXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 10:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbYKMPXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 10:23:01 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:54435 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYKMPW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 10:22:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IsygdRfwH+XiCuRMY8lu/2mdSBRVU2rRJXhlKe/jtv03pWNoOLntP+aAtNjLp2nnPQ
         cyUYOWvhmQnWNXeBdCR+f9BZnv50Wlerqw+17UpQRCYFEgmU7NqEI9BrhJDQ8G5VtSQN
         JAj7rcTdFUFBHGyYsyqQCPzCLoGcXHA5H3uLY=
Date: Thu, 13 Nov 2008 05:53:17 +0800
From: arrow.ebd@gmail.com
To: Dave Airlie <airlied@linux.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, arrow.ebd@gmail.com,
       linux_kernel <linux-kernel@vger.kernel.org>
Subject: Re: thinkpad x200 X.server not work with gm4500 graphics
Message-ID: <20081112215317.GB4682@think>
References: <20081110152518.GA3545@think> <20081111004643.8f8608a3.akpm@linux-foundation.org> <alpine.DEB.0.82.0811110849250.2182@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.82.0811110849250.2182@skynet.skynet.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 08:50:39AM +0000, Dave Airlie wrote:
> On Tue, 11 Nov 2008, Andrew Morton wrote:
> 
> > On Mon, 10 Nov 2008 23:25:18 +0800 arrow.ebd@gmail.com wrote:
> > 
> > > deal,
> > > 
> > >     My thinkpad x200's X.server can not startup on the kernel 2.6.28,
> > 
> > Were any earlier kernels OK?  If so, which version(s)?
> What userspace Intel X driver is in use? afaik the GM45 wasn't supported 
> until after we fixed this issue. Hacking around the size in the kernel 
> won't actually fix the problem it actually makes a lot of things a lot 
> worse.

My video-driver is "xf86-video-intel 2.3.2",
and "X.Org X Server 1.4.2", my distribution is Archlinux.
The patch's size is calculated with the dmesg from kernel-2.6.27.
My lap-top computer work now, but I'm not sure that, So is there any
specification about it or any suggestion, I'm glad to do some test on
it.

> > 
> > > and dmesg will show as below:
> > >     -->>--
> > >     [drm] Initialized drm 1.1.0 20060810
> > >     pci 0000:00:02.0: power state changed by ACPI to D0
> > >     pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > >     pci 0000:00:02.0: setting latency timer to 64
> > >     [drm] Initialized i915 1.6.0 20060119 on minor 0
> > >     pci 0000:00:02.0: pg_start == 0x00001f7f, intel_private.gtt_entries == 0x00001fff
> > >     pci 0000:00:02.0: trying to insert into local/stolen memory
> > >     --<<--
> > > 
> > >     Then, I change file "drivers/char/agp/intel-agp.c" as this:
> > >     -->>--
> > >     --diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
> > >     index 9cf6e9b..e681f75 100644
> > >     --- a/drivers/char/agp/intel-agp.c
> > >     +++ b/drivers/char/agp/intel-agp.c
> > >     @@ -528,7 +528,8 @@ static void intel_i830_init_gtt_entries(void)
> > >                      * stolen, ignore it in stolen gtt entries counting.  However,
> > >                      * 4KB of the stolen memory doesn't get mapped to the GTT.
> > >                      */
> > >     -               size = 4;
> > >     +               /* size = 4; */
> > >     +               size = 516;
> > >             } else {
> > >                     /* On previous hardware, the GTT size was just what was
> > >                      * required to map the aperture.
> > >     --<<--
> > > 
> > >     And Xorg can start now.
> > > (1) Is it correct ?
> > >     Because older kernel use size as "512 + 4" at here, but now use "size = 4".
> > > (2) How to deal with it if the patch is not right ?
> > > (3) How to get more specification about gm4500 ?
> > 
> > 
