Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbZHLT56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbZHLT56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 15:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZHLT56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 15:57:58 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:56869 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbZHLT55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 15:57:57 -0400
Date: Thu, 13 Aug 2009 01:27:53 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Li, Shaohua" <shaohua.li@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       "Brown, Len" <len.brown@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] cpu: idle state framework for offline CPUs.
Message-ID: <20090812195753.GA14649@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20090805142311.553.78286.stgit@sofia.in.ibm.com> <20090806015855.GA20596@sli10-desk.sh.intel.com> <20090809120818.GA1338@ucw.cz> <200908091522.02898.rjw@sisk.pl> <20090810081941.GA18649@elf.ucw.cz> <1249950137.11545.38184.camel@localhost.localdomain> <20090812115806.GK24339@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812115806.GK24339@elf.ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 01:58:06PM +0200, Pavel Machek wrote:
> Hi!
> 
> > May be having (to pick a number) 3 possible offline states for all
> > platforms with one for halt equivalent and one for deepest possible that
> > CPU can handle and one for deepest possible that platform likes for
> > C-states may make sense. Will keeps things simpler in terms of usage
> > expectations and possibly reduce the misuse oppurtubity?
> 
> Maybe just going to the deepest offline state automatically is the
> easiest option?

In a native system, I think we should the platform-specific code
export what makes sense. That may be just the lowest possible
state only. Or may be more than one.

In a virtualized system, we would want to do at least the following -

1. An offline configuration state where the hypervisor can
take the cpu back and allocate it to another VM.

2. A low-power state where the guest indicates it doesn't need the
CPU (and can be put in low power state) but doesn't want to give up 
its allocated cpu share. IOW, no visible configuration changes.

So, in any case we would probably want more than one states.

> cpu hotplug/unplug should be rare-enough operation that the latencies
> do not really matter, right?

As of now, from the platform perspective, I don't think low-power
state latencies matter in this code path. The only thing that might
have any relevance is electrical power-off technology and whether
there may be any h/w specific issues restricting its use. I don't know
that there will be any, but it may not be a good idea to prevent
platforms from requiring the use of multiple "offline" states.

Thanks
Dipankar
