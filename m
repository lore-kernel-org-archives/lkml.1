Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbXFVHNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbXFVHNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 03:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXFVHNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 03:13:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:39073 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751219AbXFVHNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 03:13:44 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18BJlEViDYBlr2ZT76iNtWUuPDNDS4ywE8HX82EC4
	mb4Rfaa2jTcbxD
Date: Fri, 22 Jun 2007 09:13:54 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <ak@suse.de>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       levon@movementarian.org, perfmon@napali.hpl.hp.com,
       oprofile-list@lists.sourceforge.net, wcohen@redhat.com,
       akpm@linux-foundation.org
Subject: Re: [perfmon] Re: [PATCH 1/2] Separate the performance counter allocation from the LAPIC NMI watchdog
Message-ID: <20070622071354.GA20506@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Stephane Eranian <eranian@hpl.hp.com>, Andi Kleen <ak@suse.de>,
	mingo@elte.hu, linux-kernel@vger.kernel.org,
	levon@movementarian.org, perfmon@napali.hpl.hp.com,
	oprofile-list@lists.sourceforge.net, wcohen@redhat.com,
	akpm@linux-foundation.org
References: <20070618103214.GA12045@atjola.homenet> <200706201431.44014.ak@suse.de> <20070620124959.GB24906@frankl.hpl.hp.com> <200706201501.02582.ak@suse.de> <20070620183315.GA3251@atjola.homenet> <20070620215933.GE26200@frankl.hpl.hp.com> <20070621083645.GA26740@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070621083645.GA26740@frankl.hpl.hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On 2007.06.21 01:36:45 -0700, Stephane Eranian wrote:
> Bjorn,
> 
> 
> On Wed, Jun 20, 2007 at 02:59:33PM -0700, Stephane Eranian wrote:
> > Bjorn,
> > 
> > I ran into one issue related with the new allocator.

Should be the same with 2.6.21 and earlier, the "new" allocator should
do exactly the samething, it just fixes the breakage introduced in the
post-2.6.21 cleanup.

> > In the case of a Core 2 Duo processor, the PMU implements more
> > than just basic counters. In particular it supports fixed counters
> > and PEBS where both use another set of MSRs. Those are not within
> > a 66 bit distance from MSR_ARCH_PERFMON_EVNTSEL0. Thus the allocator
> > fails with an assertion.

How far away are they?

> > 
> > I do know that perfmon is the only consumer of those extended 
> > features TODAY. Yet I think we need to define the allocator such
> > that it can work with other "distant" MSRs as well.
> > 
> 
> I think that a workaround for this issue could be for the allocator
> to grant the requests for registers outside of the range, i.e., register
> that it does not see/manage.

That would also allow multiple subsystems to use them at the same time.
And whoever adds the second user of those MSRs might not be aware of the
just-grant-it policy of the allocator. And bugs that arise due to such
problems will probably become a real PITA to track down.

Unfortunately, I don't see any elegant solution to this atm, and of
course making your code simply circumvent the allocator isn't an option
either.

Thanks,
Björn
