Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab0CMFpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 00:45:24 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:29972 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab0CMFpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 00:45:22 -0500
Subject: Re: Regression in i915 on 2.6.34-rc1
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: dri-devel@lists.sourceforge.net, airlied@linux.ie,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100312182519.3723e970@redhat.com>
References: <20100311003358.58194366@redhat.com>
	 <20100312182519.3723e970@redhat.com>
Content-Type: text/plain
Date: Fri, 12 Mar 2010 22:37:56 -0700
Message-Id: <1268458676.28444.9.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 18:25 -0700, Pete Zaitcev wrote:
> On Thu, 11 Mar 2010 00:33:58 -0700, Pete Zaitcev <zaitcev@redhat.com> wrote:
> 
> I apologise for answering to myself, but while there was no answer,
> git bisect found the offending commit and I verified that it was
> the culprit. Also, I am adding Bjorn and Jesse to cc:.
> 
> > I seem to hit a sudden regression in 2.6.34-rc1: the modeset fails.
> > On this box it also means, no way to start X, which is unfortunate.

Thanks for the report.  Would you mind posting the entire dmesg
log, /proc/iomem contents, and "lspci -vv" output somewhere (maybe in
bugzilla)?

The quote below isn't enough for me to see the problem, but
http://bugzilla.kernel.org/show_bug.cgi?id=15480 is another regression
related to this commit.  There are some patches for that one here:
http://lkml.org/lkml/2010/3/11/512, but without knowing more about the
problem you're seeing, I don't want to waste your time trying them.

Bjorn

> > Here's a quote from bad dmesg (truncated front and back for brievity):
> > 
> > Linux agpgart interface v0.103
> > agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
> > agpgart-intel 0000:00:00.0: detected 131068K stolen memory
> > agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
> > tpm_tis 00:09: 1.2 TPM (device-id 0xB, rev-id 16)
> > Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> > ................
> > udev: starting version 151
> > [drm] Initialized drm 1.1.0 20060810
> > i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > i915 0000:00:02.0: setting latency timer to 64
> >   alloc irq_desc for 33 on node -1
> >   alloc kstat_irqs on node -1
> > i915 0000:00:02.0: irq 33 for MSI/MSI-X
> > [drm] set up 127M of stolen space
> > [drm:i915_gem_init_ringbuffer] *ERROR* Ring head not reset to zero ctl ffffffff head ffffffff tail ffffffff start ffffffff
> > [drm:i915_gem_init_ringbuffer] *ERROR* Ring head forced to zero ctl ffffffff head ffffffff tail ffffffff start ffffffff
> > [drm:i915_gem_init_ringbuffer] *ERROR* Ring initialization failed ctl ffffffff head ffffffff tail ffffffff start ffffffff
> > [drm:i915_driver_load] *ERROR* failed to init modeset
> > i915: probe of 0000:00:02.0 failed with error -5
> > dracut: Starting plymouth daemon
> > 
...
> 
> The commit follows appended.
> 
> It's possible that the BIOS on this motherboard is not up to snuff,
> but the 2.6.33-rc8 worked fine, so clearly Linux can do it... right?
> 
> Cheers,
> -- Pete
> 
> commit 7bc5e3f2be32ae6fb0c74cd0f707f986b3a01a26
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Tue Feb 23 10:24:41 2010 -0700
> 
>     x86/PCI: use host bridge _CRS info by default on 2008 and newer machines
...

