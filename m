Return-Path: <linux-kernel-owner+w=401wt.eu-S935590AbXJPWwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935590AbXJPWwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbXJPWwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:52:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:42889 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbXJPWwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:52:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,284,1188802800"; 
   d="scan'208";a="348043594"
Date: Tue, 16 Oct 2007 15:41:42 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Greg KH <greg@kroah.com>
Cc: Mark Lord <lkml@rtr.ca>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [Pcihpd-discuss] [PATCH] Fix PCIe hotplug for Dell notebook
 ExpressCard slots
Message-Id: <20071016154142.a46905f2.kristen.c.accardi@intel.com>
In-Reply-To: <20071016220354.GA22828@kroah.com>
References: <20071016084634.8a0d695a.kristen.c.accardi@intel.com>
	<47150565.5090102@rtr.ca>
	<20071016114328.a96e8bcb.kristen.c.accardi@intel.com>
	<47150982.6050102@rtr.ca>
	<471509FE.7080505@rtr.ca>
	<47151191.40406@rtr.ca>
	<20071016130757.ed2f2ce4.kristen.c.accardi@intel.com>
	<4715217D.2000803@rtr.ca>
	<20071016214143.GC21815@kroah.com>
	<471533AF.60100@rtr.ca>
	<20071016220354.GA22828@kroah.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 15:03:54 -0700
Greg KH <greg@kroah.com> wrote:

> On Tue, Oct 16, 2007 at 05:57:03PM -0400, Mark Lord wrote:
> > Fix PCIe Hotplug so that it works with ExpressCard slots on Dell notebooks
> > in conjunction with modparam of pciehp_force=1.
> >
> > The PCIe Hotplug driver has two shortcomings when used on Dell notebooks
> > which lack ACPI BIOS support for PCIe hotplug:
> 
> Wait, Dell explicitly says that pci hotplug of express cards is not
> supported and is broken on these laptops.  This is because the version
> of Windows they support on these machines also does not support
> hotplugging these devices.

Just to add to why sometimes vendors disable PCIe hotplug by not providing
_OSC - sometimes there are problems with the hardware itself, and so
due to schedule and other reasons, vendors will decide to just disable
the support by not providing OSC, since really according to spec we shouldn't
be running the PCIe hot plug driver if OSC doesn't exist or fails.  This
can be anything from "Well, we don't have time to test it" to actual hardware
errata.  At any rate, we don't know the reasons.  I think when we force these
things, you run the danger that things will break on you in some strange
ways.

Just out of curiosity, did you try using ACPI based hotplug for this 
laptop?  Sometimes vendors will let you do that because then they can include
hardware workarounds in the AML.
