Return-Path: <linux-kernel-owner+w=401wt.eu-S1751646AbZI1NvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbZI1NvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 09:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZI1NvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 09:51:15 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:34990 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbZI1NvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 09:51:14 -0400
Date: Mon, 28 Sep 2009 19:21:03 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v3 0/3] cpu: pseries: Cpu offline states framework
Message-ID: <20090928135103.GA27218@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
 <1253016701.5506.73.camel@laptop>
 <1253753501.7103.358.camel@pasglop>
 <1253890120.18939.189.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1253890120.18939.189.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-09-25 16:48:40]:

> On Thu, 2009-09-24 at 10:51 +1000, Benjamin Herrenschmidt wrote:
> > On Tue, 2009-09-15 at 14:11 +0200, Peter Zijlstra wrote:
> > > I still think its a layering violation... its the hypervisor manager
> > > that should be bothered in what state an off-lined cpu is in. 
> > > 
> > That's not how our hypervisor works.
> 
> Then fix it?
> 
> > If you ask through the management interface, to remove a CPU from a
> > partition, the HV will communicate with a daemon inside the partition
> > that will then unplug the CPU via the right call.
> > 
> > I don't really understand your objections to be honest. And I fail to
> > see why it would be a layering violation to have the ability for the OS
> > to indicate in what state it wishes to relinguish a CPU to the
> > hypervisor, which more or less defines what is the expected latency for
> > getting it back later on.
> 
> OK, so the main objection is the abuse of CPU hotplug as resource
> management feature.
> 
> CPU hotplug is terribly invasive and expensive to the kernel, doing
> hotplug on a minute basis is just plain crazy.
> 
> If you want a CPU in a keep it near and don't hand it back to the HV
> state, why not use cpusets to isolate it and simply not run tasks on it?
> 
> cpusets don't use stopmachine and are much nicer to the rest of the
> kernel over-all.

Hi Peter,

This interface is not expected to be used every minute or so to impact
the operation of the rest of the system.  Cpuhotplug is currently used
as a resource management feature in virtualised system using dlpar
operations.  I do understand that cpu hotplug is invasive at run time
and that amount of complexity is required to carefully isolate the cpu
from any involvement in the running kernel.

Building another interface to isolate the cpus to the same extent as
cpu hotplug does today would be redundant and is going to be equally
invasive. Alternatives like cpuset for isolation migrates only tasks.

--Vaidy

