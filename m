Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbZAFUUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbZAFUUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 15:20:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZAFUTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 15:19:53 -0500
Received: from relay2.sgi.com ([192.48.179.30]:50658 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751535AbZAFUTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 15:19:52 -0500
Date: Tue, 6 Jan 2009 14:19:50 -0600
From: Robin Holt <holt@sgi.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>,
       Tony Luck <tony.luck@gmail.com>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCH] configure HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN systems
Message-ID: <20090106201950.GA3850@sgi.com>
References: <20090106162741.GA7991@sgi.com> <57C9024A16AD2D4C97DC78E552063EA35CB95575@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA35CB95575@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 12:15:34PM -0800, Luck, Tony wrote:
> > Turn on CONFIG_HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN.
> >
> > SGI Altix has unsynchronized itc clocks.  This results in rq->clock
> > occasionally being set to a time in the past by a remote cpu.
> 
> SGI Altix is definitely the worst offender here. On heterogeneneous
> systems with different model cpus across nodes the itc rate may differ
> by hundreds of megahertz.  Even when all cpus are at the same rated
> speed, different nodes are driven from different crystals, so the itc
> values will slowly drift apart (Linux discovers this from SAL and so
> doesn't bother to synchronize them).
> 
> > Note that it is possible that this problem may exist for other ia64
> > machines as well, based on the following comment for sched_clock() in
> > arch/ia64/kernel/head.S:
> >
> > * Return a CPU-local timestamp in nano-seconds.  This timestamp is
> > * NOT synchronized across CPUs its return value must never be
> > * compared against the values returned on another CPU.  The usage in
> > * kernel/sched.c ensures that.
> 
> When sched_clock() was first created this was part of its definition.
> It meant that sched_clock could be simple & fast because it didn't
> need to be synchronized across cpus.
> 
> It seems that new uses have grown for it that no longer allow that
> flexibility.
> 
> All ia64 systems are potentially affected ... but perhaps you might
> never see the problem on most because the itc clocks are synced as close
> as s/w can get them when cpus are brought on line.

Do you want Dimitri to resubmit with this set for all IA64 or leave it
as is?

Thanks,
Robin
