Return-Path: <linux-kernel-owner+w=401wt.eu-S1752186AbZIXLla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbZIXLla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZIXLl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:41:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:58976 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbZIXLl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:41:29 -0400
Date: Thu, 24 Sep 2009 13:41:23 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v2 0/2] cpu: pseries: Offline state framework.
Message-ID: <20090924134123.4acd1adf@infradead.org>
In-Reply-To: <1253791987.7695.153.camel@twins>
References: <20090828095741.10641.32053.stgit@sofia.in.ibm.com>
	<1251869611.7547.38.camel@twins>
	<1253753307.7103.356.camel@pasglop>
	<1253778667.7695.130.camel@twins>
	<1253781508.7103.437.camel@pasglop>
	<1253791987.7695.153.camel@twins>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 13:33:07 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2009-09-24 at 18:38 +1000, Benjamin Herrenschmidt wrote:
> > On Thu, 2009-09-24 at 09:51 +0200, Peter Zijlstra wrote:
> > > > I don't quite follow your logic here. This is useful for more
> > > > than just hypervisors. For example, take the HV out of the
> > > > picture for a moment and imagine that the HW has the ability to
> > > > offline CPU in various power levels, with varying latencies to
> > > > bring them back.
> > > 
> > > cpu-hotplug is an utter slow path, anybody saying latency and
> > > hotplug in the same sentence doesn't seem to grasp either or both
> > > concepts.
> > 
> > Let's forget about latency then. Let's imagine I want to set a CPU
> > offline to save power, vs. setting it offline -and- opening the back
> > door of the machine to actually physically replace it :-)
> 
> If the hardware is capable of physical hotplug, then surely powering
> the socket down saves most power and is the preferred mode?

btw just to take away a perception that generally powering down sockets
help; it does not help for all cpus. Some cpus are so efficient in idle
that the incremental gain one would get by "offlining" a core is just
not worth it
(in fact, in x86, it's the same thing)

I obviously can't speak for p-series cpus, just wanted to point out
that there is no universal truth about "offlining saves power".

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
