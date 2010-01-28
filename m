Return-Path: <linux-kernel-owner+w=401wt.eu-S932243Ab0A1Kop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab0A1Kop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 05:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932197Ab0A1Koo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 05:44:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36602 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172Ab0A1Kon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 05:44:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works 
 =?iso-8859-1?q?with=09pci=3Duse=5Fcrs?=)
Date: Thu, 28 Jan 2010 11:45:10 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc5-rjw; KDE/4.3.5; x86_64; ; )
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeff Garrett <jeff@jgarrett.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <1264652762.24020.5.camel@dc7800.home> <4B61266F.1060600@kernel.org>
In-Reply-To: <4B61266F.1060600@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001281145.10611.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 January 2010, Yinghai Lu wrote:
> On 01/27/2010 08:26 PM, Bjorn Helgaas wrote:
> > On Wed, 2010-01-27 at 15:34 -0800, Yinghai Lu wrote:
> >> On 01/27/2010 01:03 PM, Bjorn Helgaas wrote:
> >>> On Wednesday 27 January 2010 01:50:12 pm Linus Torvalds wrote:
> >>>>
> >>>> On Wed, 27 Jan 2010, Bjorn Helgaas wrote:
> >>>>>
> >>>>> Without intel_bus.c, we essentially assume config 1 all the time.
> >>>>> If we keep intel_bus.c and this patch for .33, things should work
> >>>>> for configs 1 and 4.  Adding support for config 4 is good.
> >>>>
> >>>> Quite frankly, is there any major downside to just disabling/removing 
> >>>> intel_bus.c for 2.6.33? If we're not planning on having it in the long run 
> >>>> anyway - or even if we are, but we can't be really happy about the state 
> >>>> of it as it would be in 2.6.33, not using it at all seems to be the 
> >>>> smaller headache.
> >>>>
> >>>> The machines that it helps are also the machines where you can fix things 
> >>>> up with 'use_csr', no? And they are pretty rare, and they didn't use to 
> >>>> work without that use_csr in 2.6.32 either, so it's not even a regression.
> >>>>
> >>>> Am I missing something?
> >>>
> >>> Only that when we added intel_bus.c, Yinghai reported that the reason
> >>> was because a machine had a broken _CRS, so "pci=use_crs" wouldn't help.
> >>>
> >>> At the time, Windows hadn't been brought up on that box.  My
> >>> speculation is that by now, they've done that bringup and probably
> >>> fixed the _CRS issue, so it might work now.
> >>>
> >>> If that's the case, we could drop intel_bus.c from .33 and just use
> >>> "pci=use_crs" on those boxes until we can figure out how to turn it
> >>> on automatically.
> >>
> >> BIOS fixed that problem already. but
> >> 1. how to turn that pci=use_crs for that box automatically ?
> >> how about our other kind of boxes?
> > 
> > Yes, we need a way to turn on "pci=use_crs" automatically.  My first
> > thought is to turn it on for all BIOSes with dates of 2010 or later, and
> > in addition, have a whitelist of the pre-2010 machines that require it.
> > 
> >> 2. how about when apci is disabled?
> > 
> > When ACPI is disabled, I think we just have to accept that we lose some
> > functionality.  I don't see the need for alternate ways to accomplish
> > everything that ACPI does.  It's becoming less and less useful to
> > disable ACPI; I think it's only interesting as a debugging tool, and
> > even then it's a sledgehammer.
> 
> some systems when acpi is enabled could have interrupt storm. 
> and have to disable acpi.

Blacklist them?

Rafael
