Return-Path: <linux-kernel-owner+w=401wt.eu-S1758899AbYGKV7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbYGKV7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 17:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbYGKV7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 17:59:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:29220 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbYGKV7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 17:59:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,347,1212390000"; 
   d="scan'208";a="309366550"
Date: Fri, 11 Jul 2008 14:59:43 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matthew Wilcox <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "jgarzik@pobox.com" <jgarzik@pobox.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
       "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
Subject: Re: Multiple MSI, take 3
Message-ID: <20080711215943.GW1678@linux-os.sc.intel.com>
References: <20080711005719.GO14894@parisc-linux.org> <m1iqvc91li.fsf@frodo.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1iqvc91li.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 03:06:33AM -0700, Eric W. Biederman wrote:
> Matthew Wilcox <matthew@wil.cx> writes:
> 
> > I'd like to thank Michael Ellerman for his feedback.  This is a much
> > better patchset than it used to be.
> 
> There is a reason we don't have an API to support this.  Linux can not
> reasonably support this, especially not on current X86.  The designers
> of the of the AHCI were idiots and should have used MSI-X.
> 
> Attempting to support multiple irqs in an MSI capability breaks
> every interesting use of an irq.
> 
> mask/unmask is will likely break because the mask bit is optional
> and when it is not present we disable the msi capability.
> 
> We can not set the affinity individually so we can not allow
> different queues to be processed on different cores.
> 
> So in general it seems something that we have to jump through a million
> hurdles and the result is someones twisted parody of a multiple working
> irqs, that even Intel's IOMMU can't cure.

With interrupt-remapping, we can program the individual interrupt
remapping table entries to point to different cpu's etc. All we have
to take care is, do the IRTE allocation in a consecutive block and
program the starting index to the MSI registers.

Just curious Eric, why do you think that won't work?

thanks,
suresh

> So unless the performance of the AHCI is better by a huge amount I don't
> see the point, and even then I am extremely sceptical.
> 
> Eric
