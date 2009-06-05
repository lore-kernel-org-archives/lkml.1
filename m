Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbZFEWU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbZFEWU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 18:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZFEWUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 18:20:16 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55430 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZFEWUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 18:20:14 -0400
Date: Fri, 5 Jun 2009 15:20:04 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "travis@sgi.com" <travis@sgi.com>, "steiner@sgi.com" <steiner@sgi.com>,
       Gary Hade <garyhade@us.ibm.com>, lcm@us.ibm.com
Subject: Re: [patch] x64: Avoid irq_chip mask/unmask in fixup_irqs for
	interrupt-remapping
Message-ID: <20090605222004.GE7514@us.ibm.com>
References: <1244141989.27006.10369.camel@localhost.localdomain> <m1iqjbd243.fsf@fess.ebiederm.org> <1244164694.27006.10374.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244164694.27006.10374.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 06:18:14PM -0700, Suresh Siddha wrote:
> On Thu, 2009-06-04 at 16:13 -0700, Eric W. Biederman wrote:
> > Suresh Siddha <suresh.b.siddha@intel.com> writes:
> > 
> > > From: Suresh Siddha <suresh.b.siddha@intel.com>
> > > Subject: x64: Avoid irq_chip mask/unmask in fixup_irqs for interrupt-remapping
> > >
> > > In the presence of interrupt-remapping, irqs will be migrated in the
> > > process context and we don't do (and there is no need to) irq_chip mask/unmask
> > > while migrating the interrupt.
> > >
> > > Similarly fix the fixup_irqs() that get called during cpu offline and avoid
> > > calling irq_chip mask/unmask for irqs that are ok to be migrated in the
> > > process context.
> > >
> > > While we didn't observe any race condition with the existing code,
> > > this change takes complete advantage of interrupt-remapping in
> > > the newer generation platforms and avoids any potential HW lockup's
> > > (that often worry Eric :)
> > 
> > You now apparently fail to migrate the irq threads in tandem with
> > the rest of the irqs.
> 
> Eric, Are you referring to Gary's issues? As far as I understand, they
> don't happen in the presence of interrupt-remapping.

Suresh,
We do not currently have the h/w on which to test this assertion
but it seems like there is a good chance that at least the race that
  http://lkml.org/lkml/2009/6/2/377
fixes could reproduce there.

The other problem that is repaired by
  http://lkml.org/lkml/2009/6/2/378
depends on the i/o redirection table write with remote IRR bit
set lockup anomaly that the interrupt-remapping code may avoid
or perhaps is not even present with that h/w.  My proposed fix
for the problem is based on previous interrupt-remapping code
that you recently removed with
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=0280f7c416c652a2fd95d166f52b199ae61122c0
If I correctly understand your justification for the change
it sounds like the interrupt-remapping code now "avoids" the problem.

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
