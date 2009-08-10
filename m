Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbZHJCAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbZHJCAx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 22:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbZHJCAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 22:00:52 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:41948 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbZHJCAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 22:00:51 -0400
Date: Mon, 10 Aug 2009 07:30:05 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Shaohua Li <shaohua.li@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       "Brown, Len" <len.brown@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] cpu: idle state framework for offline CPUs.
Message-ID: <20090810020005.GA1395@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090805142311.553.78286.stgit@sofia.in.ibm.com>
 <20090806015855.GA20596@sli10-desk.sh.intel.com>
 <20090809120818.GA1338@ucw.cz>
 <200908091522.02898.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <200908091522.02898.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki <rjw@sisk.pl> [2009-08-09 15:22:02]:

> On Sunday 09 August 2009, Pavel Machek wrote:
> > Hi!
> > 
> > > > Also, approaches such as [1] can make use of this
> > > > extended infrastructure instead of putting the CPU to an arbitrary C-state
> > > > when it is offlined, thereby providing the system administrator a rope to hang
> > > > himself with should he feel the need to do so.
> > > I didn't see the reason why administrator needs to know which state offline cpu
> > > should stay. Don't know about powerpc side, but in x86 side, it appears deepest
> > > C-state is already preferred.
> > > 
> > 
> > Agreed, deepest c-state is always best, there's no need to make it configurable.
> 
> Unless it doesn't work.

Yes, this is one of the reason.  Kernel will know about the deepest
sleep state and any restrictions and should set that as default in the
preferred_offline state. End-users and sys-admins need not change it,
default will be the deepest sleep state supported and allowed by the
system which may be different than the one supported by the processor.

This framework could allow the default to be set easily by other
userspace tools.  These restrictions apply to cpuidle governor as
well, hence at some level both these subsystems should be in sync.

As described in this patch series, the meaning of offline cpu is
different in a virtualized system and this framework provides
flexibility of choice there.  Platforms today do have a choice on what
state an offline cpu should reside, this framework is one of the
possible methods to exploit that choice and not restrict it due to
lack of OS flexibility.

--Vaidy

