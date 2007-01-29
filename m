Return-Path: <linux-kernel-owner+w=401wt.eu-S933018AbXA2A3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbXA2A3O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 19:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933020AbXA2A3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 19:29:14 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43446 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933018AbXA2A3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 19:29:13 -0500
Date: Sun, 28 Jan 2007 16:29:07 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Dave Airlie" <airlied@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net,
       "Giuseppe Bilotta" <giuseppe.bilotta@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
Message-Id: <20070128162907.370f5476.akpm@osdl.org>
In-Reply-To: <21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com>
References: <ephv35$4i3$1@sea.gmane.org>
	<20070128160831.fb51347f.akpm@osdl.org>
	<21d7e9970701281612q56b694edp6efd1a5556dea3fe@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 11:12:57 +1100
"Dave Airlie" <airlied@gmail.com> wrote:

> > > Some nVidia video cards have broken EDID information. Using nvidiafb
> > > with CONFIG_FB_NVIDIA_I2C enabled on these systems causes the console
> > > framebuffer to use wrong timing information, causing the display to be
> > > extremely 'snowy'. Since most distribution kernels are compiled with
> > > CONFIG_FB_NVIDIA_I2C enabled, this prevents usage of the nvidia
> > > framebuffer on said broken system without recompiling the kernel
> > > (or at least the nvidiafb module).
> > >
> > > Solve the issue by introducing a new boolean module parameter (useedid)
> > > which can be set to 0 to prevent the driver from using the EDID
> > > information.
> > >
> > > If this patch is accepted, we can probably get rid of CONFIG_FB_NVIDIA_I2C
> > > altogether.
> > >
> >
> > That's a pretty sad solution.  Is it possible to detect these bad cards at
> > runtime via ther behaviour?  If not, can we generate a blacklist for the
> > known-bad cards based on PCI IDs or something?
> >
> > Because most users won't even be aware of the module option: they'll just
> > know that their card doesn't work right.
> 
> This isn't a card problem this is a monitor problem, the card just
> passes through the edid data from the monitor... or else the
> programming of the card registers from edid is wrong..

In which case the same problem would occur with different video cards, so
this patch should be some generic thing, available to all drivers, no?
