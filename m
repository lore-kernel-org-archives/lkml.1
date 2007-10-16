Return-Path: <linux-kernel-owner+w=401wt.eu-S935898AbXJPUOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935898AbXJPUOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934944AbXJPUNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:13:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:5337 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934624AbXJPUNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:13:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,284,1188802800"; 
   d="scan'208";a="347918213"
Date: Tue, 16 Oct 2007 13:07:57 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Mark Lord <lkml@rtr.ca>
Cc: pcihpd-discuss@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIe Hotplug:  NFG unless I boot with card already inserted.
Message-Id: <20071016130757.ed2f2ce4.kristen.c.accardi@intel.com>
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

I tried to reproduce this on a Lenovo T61, which does have proper firmware
support for _OSC, and also has been validated, and the driver which is 
in 2.6.23-git8 seems to work fine, even across suspend resume.  I suspect
that your system just doesn't support pcie hotplug properly.

You might try getting a BIOS update from Dell.
