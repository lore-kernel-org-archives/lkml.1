Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbXEYEdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbXEYEdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 00:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXEYEc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 00:32:56 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332AbXEYEcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 00:32:55 -0400
Date: Thu, 24 May 2007 21:31:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, <linux-kernel@vger.kernel.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
Message-Id: <20070524213157.1d39458f.akpm@linux-foundation.org>
In-Reply-To: <m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
References: <200705122146.l4CLkH6q012322@fire-2.osdl.org>
	<m1mz09p1t7.fsf@ebiederm.dsl.xmission.com>
	<20070513014622.c5702928.akpm@linux-foundation.org>
	<46470209.9000502@bellsouth.net>
	<46470515.50000@NineX.eu.org>
	<464707F7.6080600@bellsouth.net>
	<m1irawpwy2.fsf@ebiederm.dsl.xmission.com>
	<20070513204407.7ba35010@osprey.hogchain.net>
	<4647FA38.3090108@NineX.eu.org>
	<46480EA5.40400@NineX.eu.org>
	<20070514053406.478bf93f@osprey.hogchain.net>
	<m1d513oddj.fsf@ebiederm.dsl.xmission.com>
	<20070514093829.377e04bc@osprey.hogchain.net>
	<m18xbrnyxi.fsf@ebiederm.dsl.xmission.com>
	<20070514160005.627435e3@osprey.hogchain.net>
	<m1odkmmft4.fsf@ebiederm.dsl.xmission.com>
	<20070515212200.517fcba2@osprey.hogchain.net>
	<m14pmcmz8r.fsf@ebiederm.dsl.xmission.com>
	<20070516185225.3f3ac082@osprey.hogchain.net>
	<m1sl9wl28m.fsf@ebiederm.dsl.xmission.com>
	<20070522204103.134bf5a2@osprey.hogchain.net>
	<m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 22:19:09 -0600 ebiederm@xmission.com (Eric W. Biederman) wrote:

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

Yup.

Do we have a feel for how much performace we're losing on those 
systems which _could_ do MSI, but which will end up defaulting
to not using it?
