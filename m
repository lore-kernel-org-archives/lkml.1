Return-Path: <linux-kernel-owner+w=401wt.eu-S935856AbXJPT60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935856AbXJPT60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935757AbXJPT5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:57:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:10334 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935751AbXJPT5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:57:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,284,1188802800"; 
   d="scan'208";a="175608300"
Date: Tue, 16 Oct 2007 12:51:17 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Mark Lord <lkml@rtr.ca>
Cc: pcihpd-discuss@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIe Hotplug:  NFG unless I boot with card already inserted.
Message-Id: <20071016125117.d7116ec2.kristen.c.accardi@intel.com>
In-Reply-To: <47151191.40406@rtr.ca>
References: <4714C0A6.1030204@rtr.ca>
	<4714D700.7060008@rtr.ca>
	<20071016084634.8a0d695a.kristen.c.accardi@intel.com>
	<47150565.5090102@rtr.ca>
	<20071016114328.a96e8bcb.kristen.c.accardi@intel.com>
	<47150982.6050102@rtr.ca>
	<471509FE.7080505@rtr.ca>
	<47151191.40406@rtr.ca>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 15:31:29 -0400
Mark Lord <lkml@rtr.ca> wrote:

> Mark Lord wrote:
> > Mark Lord wrote:
> >> Kristen Carlson Accardi wrote:
> >>> On Tue, 16 Oct 2007 14:39:33 -0400
> >>> Mark Lord <lkml@rtr.ca> wrote:
> >>>
> >>>> I also checked my modprobe.d/ options, and I am using pciehp_force=1.
> >>>> Without that flag, none of this ever works.
> >>>
> >>> OK - I suspected something like this.  Most Dell computers don't support
> >>> ExpressCard hotplug using Native PCIe -- in fact, I've not seen a single
> >>> one, they explicitly disable it because they have not validated it or
> >>> they have and something didn't work right.  I'll take a look at what 
> >>> you've
> >>> got, but be aware that you are forcing pciehp to load and operate on 
> >>> a system
> >>> where they've certainly either not tested it, or tested it and something
> >>> bad happened.
> >>
> >> Perhaps.  But this one works perfectly, except for two driver bugs:
> >>
> >> 1. Driver does not notice already-inserted cards after modprobe.
> >> 2. Driver fails to function after suspend/resume until reloaded.
> >>
> >> Both of those are fixable in the kernel.
> > 
> > Ahh.. point 2 in particular suffers from "suspend/resume" not implemented.
> > Or rather, implemented as a pair of "do nothing" functions.
> 
> This patch below seems to fix point 1 on my system,
> causing pciehp to become aware of already-inserted cards on module load.
> 
> It's not perfect, but I believe it does show the kind of functionality
> that's missing from the driver.

No - it's not broken.  Powering off the slot if it is not occupied is the
right thing to do - the controller when it is working properly will detect
the presence of a new adapter and interrupt.  

I'll try to duplicate your problem on a piece of hardware that has proper
firmware support and validated hardware and then we'll go from there.

We could very well have software problems, especially with ExpressCard
since most pciehp use is for servers, but we should make sure we aren't
writing workarounds for broken hardware first.
