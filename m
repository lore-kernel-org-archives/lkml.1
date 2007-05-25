Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbXEYFTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbXEYFTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 01:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbXEYFTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 01:19:31 -0400
Received: from mx1.suse.de ([195.135.220.2]:58580 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbXEYFTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 01:19:30 -0400
Date: Thu, 24 May 2007 22:20:32 -0700
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
Message-ID: <20070525052032.GB9386@suse.de>
References: <20070514093829.377e04bc@osprey.hogchain.net> <m18xbrnyxi.fsf@ebiederm.dsl.xmission.com> <20070514160005.627435e3@osprey.hogchain.net> <m1odkmmft4.fsf@ebiederm.dsl.xmission.com> <20070515212200.517fcba2@osprey.hogchain.net> <m14pmcmz8r.fsf@ebiederm.dsl.xmission.com> <20070516185225.3f3ac082@osprey.hogchain.net> <m1sl9wl28m.fsf@ebiederm.dsl.xmission.com> <20070522204103.134bf5a2@osprey.hogchain.net> <m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 10:19:09PM -0600, Eric W. Biederman wrote:
> 
> Currently we blacklist known bad msi configurations which means we
> keep getting MSI enabled on chipsets that either do not support MSI,
> or MSI is implemented improperly.  Since the normal IRQ routing
> mechanism seems to works even when MSI does not, this is a bad default
> and causes non-functioning systems for no good reason.
> 
> So this patch inverts the sense of the MSI bus flag to only enable
> MSI on known good systems.  I am seeding that list with the set of
> chipsets with an enabled hypertransport MSI mapping capability.  Which
> is as close as I can come to an generic MSI enable.  So for actually
> using MSI this patch is a regression, but for just having MSI enabled
> in the kernel by default things should just work with this patch
> applied.
> 
> People can still enable MSI on a per bus level for testing by writing
> to sysfs so discovering chipsets that actually work (assuming we are
> using modular drivers) should be pretty straight forward.

Originally I would have thought this would be a good idea, but now that
Vista is out, which supports MSI, I don't think we are going to need
this in the future.  All new chipsets should support MSI fine and this
table will only grow in the future, while the blacklist should not need
to have many new entries added to it.

So I don't think this is a good idea, sorry.

greg k-h
