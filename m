Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbYCDJOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbYCDJOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760470AbYCDJOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:14:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759557AbYCDJOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:14:12 -0500
Date: Tue, 4 Mar 2008 01:13:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan McDowell <noodles@earth.li>
Cc: Dave Airlie <airlied@linux.ie>, xorg-driver-ati@lists.x.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3 + RS690 + DRM + xf86-video-ati hang
Message-Id: <20080304011332.639a0551.akpm@linux-foundation.org>
In-Reply-To: <20080304085155.GX9009@earth.li>
References: <20080301193511.GP9009@earth.li>
	<20080303224830.28e98b2b.akpm@linux-foundation.org>
	<alpine.DEB.0.82.0803040816180.24971@skynet.skynet.ie>
	<20080304085155.GX9009@earth.li>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 08:51:55 +0000 Jonathan McDowell <noodles@earth.li> wrote:

> On Tue, Mar 04, 2008 at 08:16:49AM +0000, Dave Airlie wrote:
> > On Mon, 3 Mar 2008, Andrew Morton wrote:
> > > On Sat, 1 Mar 2008 19:35:11 +0000 Jonathan McDowell <noodles@earth.li>
> > > wrote:
> > > 
> > > > If I enable CONFIG_DRM_RADEON under 2.6.25-rc3 then starting up
> > > > X using the xf86-video-ati driver (6.8.0 or latest git) causes the
> > > > machine to become unresponsive; while it still pings and will accept
> > > > incoming connections they never actually complete and it's not possible
> > > > to login over a serial console (the actual video console doesn't display
> > > > anything and the monitor reports a loss of sync).
> > > > 
> > > > Disabling the kernel DRM option results in X running successfully.
> > > > Likewise 2.6.24 works fine with DRM enabled, presumably because the
> > > > support for the RS690 was only added in 2.6.25-rc
> > > > 
> > > > The last messages from the kernel before it becomes unresponsive are:
> > > > 
> > > > [drm] Setting GART location based on new memory map
> > > > [drm] Loading R300 Microcode
> > > > [drm] writeback test succeeded in 1 usecs
> > > > 
> > > > The motherboard in question is an ASUS M2A-VM HDMI, with the analog VGA
> > > > output being used. The machine is running an AMD64 with Debian unstable.
> > > > I have put the output of lspci, a non drm Xorg.log and a drm Xorg.log
> > > > at:
> > > > 
> > > > http://the.earth.li/~noodles/xorg-ati-drm/lspci
> > > > http://the.earth.li/~noodles/xorg-ati-drm/Xorg.0.log-nodrm
> > > > http://the.earth.li/~noodles/xorg-ati-drm/Xorg.0.log-drm
> > > > 
> > > > If I can provide any more useful information please let me know.
> > > > 
> > > 
> > > Did 2.6.24 work OK with all the same userspace software?
> > > 
> > We haven't actually released any userspace software properly yet, its all 
> > experimental at this point until we debug the hardware some more..
> 
> Is xf86-driver-ati 6.8.0 not a proper release? I'm pretty sure the
> combination of that, 2.6.25-rc3 and CONFIG_DRM_RADEON causes my machine
> to become unresponsive. I only tried a git build of the driver after the
> released version was causing issues.

This:

> Replacing 2.6.25-rc3 with 2.6.24 (still with CONFIG_DRM_RADEON enabled)
> results in a machine that boots to GDM successfully. Likewise if I
> disable CONFIG_DRM_RADEON in 2.6.25-rc3 the machine boots to GDM ok.

is what we wanted to know, thanks.  Surely it's a plain old regression?
