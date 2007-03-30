Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbXC3U1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbXC3U1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 16:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbXC3U1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 16:27:11 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50617 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbXC3U1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 16:27:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mitch Williams <mitch.a.williams@intel.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       auke-jan.h.kok@intel.com
Subject: Re: [PATCH 2.6.21-rc5] Flush MSI-X table writes (rev 3)
References: <1175280848.17652.5.camel@strongmad>
	<m1irciime5.fsf@ebiederm.dsl.xmission.com>
	<20070330124747.f20c9eb0.akpm@linux-foundation.org>
	<20070330194956.GA8028@suse.de>
Date: Fri, 30 Mar 2007 14:26:03 -0600
In-Reply-To: <20070330194956.GA8028@suse.de> (Greg KH's message of "Fri, 30
	Mar 2007 12:49:56 -0700")
Message-ID: <m14po2iilg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Fri, Mar 30, 2007 at 12:47:47PM -0700, Andrew Morton wrote:
>> Did we end up deciding whether this is (needed*safe) enough for 2.6.21?
>
> I say no for now, I have seen no bug reports for any hardware that is
> not in a lab for this.

The bug report would be phrased as someone seeing "No irq for vector"
on x86_64.  Unless they are a skilled developer they are unlikely to
trace it down to not flushing posted writes to a MSI bar during irq
migration.  It part it is a subtle hardware/software race.

I have seen some unresolved bug reports described this way on machines
that have MSI-X capable hardware.  The are against fedora core and I
can't haven't been able to get the reporters to try 2.6.21-rcX and
the other irq back ports don't work so well.

I currently count 7 drivers in 2.6.21 that are susceptible to the race
this bug closes.

This version of the patch seems to meet all of the criteria for being
obviously correct, and all it does is insert a stupid readl.  Not
very dangerous.

This fix removes a race between hardware and software that you likely
need to migrate MSI-X irqs a lot to trigger.  Which can be the kind of
thing that bytes you after you have a month of uptime.  This is a very
nasty condition to track down from bug reports.  I'd rather not have a
known culprit out there.

Eric
