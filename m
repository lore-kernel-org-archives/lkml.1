Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYBKW0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYBKW0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbYBKWZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:25:58 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59189 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754523AbYBKWZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:25:56 -0500
Date: Mon, 11 Feb 2008 14:10:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: matthew@wil.cx, arjan@infradead.org, hancockr@shaw.ca,
       torvalds@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       tcamuso@redhat.com, grundler@parisc-linux.org, loic@myri.com,
       bunk@kernel.org, benh@kernel.crashing.org, ink@jurassic.park.msu.ru,
       gregkh@suse.de, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-pci@atrey.karlin.mff.cuni.cz, mj@ucw.cz
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
Message-Id: <20080211141006.0aadac6c.akpm@linux-foundation.org>
In-Reply-To: <86802c440802101749h5af30b4dm1836f881a898652e@mail.gmail.com>
References: <20080129025615.GC20198@parisc-linux.org>
	<86802c440802022330o771cf98btcf750c790668b6e9@mail.gmail.com>
	<47AB299D.4000500@redhat.com>
	<20080209124138.GA28967@parisc-linux.org>
	<86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com>
	<20080210072116.GA12375@kroah.com>
	<20080210145122.GC5299@parisc-linux.org>
	<86802c440802101216t3b04c0b4y89a05ac9a04a0ac5@mail.gmail.com>
	<alpine.LFD.1.00.0802101222560.2896@woody.linux-foundation.org>
	<20080210204556.GG5299@parisc-linux.org>
	<86802c440802101749h5af30b4dm1836f881a898652e@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2008 17:49:34 -0800
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On Feb 10, 2008 12:45 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> >
> > On Sun, Feb 10, 2008 at 12:24:18PM -0800, Linus Torvalds wrote:
> > > On Sun, 10 Feb 2008, Yinghai Lu wrote:
> > > > >
> > > > > I suggest Ivan's patch be merged ASAP as it actually fixes bugs.
> > > > > This patch is just cleanup (and takes care of some future concerns).
> > > >
> > > > your patch and Ivan's patch should be merged in one...
> > >
> > > I really don't care whether they get merges as one or separately, but I
> > > think it should be merged _now_ (-rc1 is already delayed), and I'd like to
> > > see the final versions of both. Does anybody have them in a final
> > > agreed-upon format (preferably with that oddness in quirk_intel_irqbalance
> > > also fixed?)
> >
> > I just looked at fixing that -- the reason seems to be that we don't
> > actually have the struct pci_dev at that point.  I can fix it, but I
> > think it's actually buggy.  I want to look at some chipset docs to
> > confirm that though.
> >
> > I've attached the two patches that I believe are the ones we want.  We
> > can (and should) fix quirk_intel_irqbalance separately.
> 
> Andrew,
> 
> those two patch just got into linus 2.6.25-rc1.
> 
> I assume that you will drop
> gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch in
> -mm.

That's no longer in Greg's tree.

> please check some updated patches in -mm that could be affected. hope
> it could save you some time
> 
> x86-validate-against-acpi-motherboard-resources.patch
> x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
> x86-mmconf-enable-mcfg-early.patch
> x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch

I have unhappy feelings here - the patches seem to be churning a bit
and when I last sent them to Greg and Ingo they received no apparent
response.

So I think I'll just drop all four.  Please redo, retest and fully
resubmit, thanks.

And we need to work out who owns these patches.  Are they rightly part of
the PCI tree, or of the x86 tree?

