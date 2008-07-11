Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbYGKXPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbYGKXPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 19:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbYGKXPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 19:15:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:52197 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbYGKXPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 19:15:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,348,1212390000"; 
   d="scan'208";a="592073147"
Date: Fri, 11 Jul 2008 16:15:43 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Matthew Wilcox <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "jgarzik@pobox.com" <jgarzik@pobox.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
       "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
Subject: Re: Multiple MSI, take 3
Message-ID: <20080711231543.GY1678@linux-os.sc.intel.com>
References: <20080711005719.GO14894@parisc-linux.org> <m1iqvc91li.fsf@frodo.ebiederm.org> <20080711215943.GW1678@linux-os.sc.intel.com> <m1d4lkauxc.fsf@frodo.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d4lkauxc.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 03:59:59PM -0700, Eric W. Biederman wrote:
> Suresh Siddha <suresh.b.siddha@intel.com> writes:
> 
> > With interrupt-remapping, we can program the individual interrupt
> > remapping table entries to point to different cpu's etc. All we have
> > to take care is, do the IRTE allocation in a consecutive block and
> > program the starting index to the MSI registers.
> >
> > Just curious Eric, why do you think that won't work?
> 
> Working mask/unmask.  With MSI-X as specced if I mask an irq and then unmask
> it, an msi message will fire if something happened while the irq was masked
> and not taken care of before the irq was unmasked.  That is the correct
> behavior for an irq and a mmu won't let me get that.

And why do we need to mask/unmask the device in the interrupt-remapping case?

> 
> The best I can do with an iommu is to run delayed disable and set the
> interrupt remapping slot in the iommu to reject the traffic.  Which
> is almost but not quite what I want.
> 
> Overall introducing a new concept into the linux irq model seems a lot
> cleaner and more portable, and even there we are likely to be a lot
> more fragile because of the difficulty in obtaining contiguous
> vectors.
> 
> Speaking of.  How many interrupt targets does the dmar iommu have
> for interrupts?  16K?

There can be multiple interrupt-remapping units in the platform and
each of table in the remapping unit has max 64K entries.

thanks,
suresh
