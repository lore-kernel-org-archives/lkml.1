Return-Path: <linux-kernel-owner+w=401wt.eu-S1763251AbXJRQ1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763251AbXJRQ1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 12:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbXJRQ1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 12:27:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:48046 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbXJRQ1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 12:27:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,296,1188802800"; 
   d="scan'208";a="250208547"
Date: Thu, 18 Oct 2007 09:13:47 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, greg@kroah.com,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [PATCH 0/3] Fix two PEIe hotplug issues
Message-Id: <20071018091347.4b94faf8.kristen.c.accardi@intel.com>
In-Reply-To: <4716CE79.7040201@rtr.ca>
References: <4716CB9D.6080503@rtr.ca>
	<4716CE79.7040201@rtr.ca>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 23:09:45 -0400
Mark Lord <lkml@rtr.ca> wrote:

> Mark Lord wrote:
> > Fix PCIe Hotplug so that it works with ExpressCard slots on Dell notebooks
> > (and others?) in conjunction with the modparam of pciehp_force=1.
> 
> 
> To make things simpler for distro people, I'm contemplating another patch
> in this series, to allow something like:  pciehp_force=2
> 
> This would then *try* the ACPI BIOS calls, and only fall back to pcie_force=1
> if the BIOS support fails.  This would be an ideal default for most desktop/notebook
> distros to consider using.
> 
> Without this, they don't have any good choice:  use the defaults, and things fail
> on the most popular brand of machines in the marketplace.  Use pciehp_force=1,
> and they may break (?) on other brands.
> 
> So a hybrid of the two seems best.  Pity it couldn't be the default behaviour, though.
> Or could it?  We're early enough in the 2.6.24 cycle for it..
> 
> Opinions?
> 

NAK!  Absolutely no way will I take a patch that does this.  
I've been actually having philosophical issues with
even having pciehp_force as a module parameter at all.  As I said before,
using pciehp_force violates the PCI spec.  Vendors often deliberately 
do not support OSC due to hardware errata.  Users who use this option risk
breaking their laptop.  I was thinking actually that we should make it
more difficult to use this option, like make it a compile time option,
or perhaps rename it to this_could_seriously_break_your_hardware_dont_use.

Probably we shouldn't have the functionality in the driver at all, but
I don't really want to take it out all together, because it's handy for those
of us who work on early hardware, where we can ask the BIOS people why
they didn't implement OSC, and then consciously force it knowing exactly
what we are doing and the potential consequences.  But, maybe we should
consider the possibility that we should remove the code so as to really
really prevent distros from using this option.

