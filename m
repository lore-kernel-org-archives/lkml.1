Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbZAFU5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbZAFU5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 15:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbZAFU52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 15:57:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:42795 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbZAFU51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 15:57:27 -0500
Subject: RE: [PATCH] configure HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN systems
From: Peter Zijlstra <peterz@infradead.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Robin Holt <holt@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>,
       Tony Luck <tony.luck@gmail.com>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA35CB955B4@orsmsx505.amr.corp.intel.com>
References: <20090106162741.GA7991@sgi.com>
	 <57C9024A16AD2D4C97DC78E552063EA35CB95575@orsmsx505.amr.corp.intel.com>
	 <20090106201950.GA3850@sgi.com>
	 <57C9024A16AD2D4C97DC78E552063EA35CB955B4@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Jan 2009 21:57:20 +0100
Message-Id: <1231275441.11687.110.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 12:34 -0800, Luck, Tony wrote:
> > > All ia64 systems are potentially affected ... but perhaps you might
> > > never see the problem on most because the itc clocks are synced as close
> > > as s/w can get them when cpus are brought on line.
> >
> > Do you want Dimitri to resubmit with this set for all IA64 or leave it
> > as is?
> 
> I'd like to understand the impact of turning on HAVE_UNSTABLE_SCHED_CLOCK
> 
> It looks like both the i386_defconfig and x86_64_defconfig choose this,
> so at least ia64 will be hitting the well tested code paths
> 
> Have the other architectures just not hit this yet?  Or do they all have
> "stable" sched_clock() functions?
> 
> 
> sched_clock() seemed like such a straightforward thing to begin with. A
> quick & easy way to measure a time delta ON THE SAME CPU.  I'm not at
> all sure why it has been co-opted for general time measurement.

It came from the complication of needing to tell a remote cpu's time due
to remote wakeups in the scheduler.
