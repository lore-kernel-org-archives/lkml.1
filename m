Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbZIYH1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbZIYH1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 03:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZIYH1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 03:27:43 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:40662 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbZIYH1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 03:27:42 -0400
Date: Fri, 25 Sep 2009 12:55:49 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v2 0/2] cpu: pseries: Offline state framework.
Message-ID: <20090925072549.GB9562@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090828095741.10641.32053.stgit@sofia.in.ibm.com>
 <1251869611.7547.38.camel@twins>
 <1253753307.7103.356.camel@pasglop>
 <1253778667.7695.130.camel@twins>
 <1253781508.7103.437.camel@pasglop>
 <1253791987.7695.153.camel@twins>
 <20090924134123.4acd1adf@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090924134123.4acd1adf@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven <arjan@infradead.org> [2009-09-24 13:41:23]:

> On Thu, 24 Sep 2009 13:33:07 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Thu, 2009-09-24 at 18:38 +1000, Benjamin Herrenschmidt wrote:
> > > On Thu, 2009-09-24 at 09:51 +0200, Peter Zijlstra wrote:
> > > > > I don't quite follow your logic here. This is useful for more
> > > > > than just hypervisors. For example, take the HV out of the
> > > > > picture for a moment and imagine that the HW has the ability to
> > > > > offline CPU in various power levels, with varying latencies to
> > > > > bring them back.
> > > > 
> > > > cpu-hotplug is an utter slow path, anybody saying latency and
> > > > hotplug in the same sentence doesn't seem to grasp either or both
> > > > concepts.
> > > 
> > > Let's forget about latency then. Let's imagine I want to set a CPU
> > > offline to save power, vs. setting it offline -and- opening the back
> > > door of the machine to actually physically replace it :-)
> > 
> > If the hardware is capable of physical hotplug, then surely powering
> > the socket down saves most power and is the preferred mode?
> 
> btw just to take away a perception that generally powering down sockets
> help; it does not help for all cpus. Some cpus are so efficient in idle
> that the incremental gain one would get by "offlining" a core is just
> not worth it
> (in fact, in x86, it's the same thing)
> 
> I obviously can't speak for p-series cpus, just wanted to point out
> that there is no universal truth about "offlining saves power".

Hi Arjan,

As you have said, on some cpus the extra effort of offlining does not
save us any extra power, and the state will be same as idle.  The
assertion that offlining saves power is still valid, it could be same
as idle or better depending on the architecture and implementation.

On x86 we still need the code (Venki posted) to take cpus to C6 on
offline to save power or else offlining consumes more power than idle
due to C1/hlt state.  This framework can help here as well if we have
any apprehension on making lowest sleep state as default on x86 and
want the administrator to decide.

--Vaidy
