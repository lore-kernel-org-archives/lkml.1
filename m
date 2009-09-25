Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbZIYOs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbZIYOs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 10:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZIYOs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 10:48:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54635 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbZIYOsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 10:48:55 -0400
Subject: Re: [PATCH v3 0/3] cpu: pseries: Cpu offline states framework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <1253753501.7103.358.camel@pasglop>
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
	 <1253016701.5506.73.camel@laptop>  <1253753501.7103.358.camel@pasglop>
Content-Type: text/plain
Date: Fri, 25 Sep 2009 16:48:40 +0200
Message-Id: <1253890120.18939.189.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 10:51 +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2009-09-15 at 14:11 +0200, Peter Zijlstra wrote:
> > I still think its a layering violation... its the hypervisor manager
> > that should be bothered in what state an off-lined cpu is in. 
> > 
> That's not how our hypervisor works.

Then fix it?

> If you ask through the management interface, to remove a CPU from a
> partition, the HV will communicate with a daemon inside the partition
> that will then unplug the CPU via the right call.
> 
> I don't really understand your objections to be honest. And I fail to
> see why it would be a layering violation to have the ability for the OS
> to indicate in what state it wishes to relinguish a CPU to the
> hypervisor, which more or less defines what is the expected latency for
> getting it back later on.

OK, so the main objection is the abuse of CPU hotplug as resource
management feature.

CPU hotplug is terribly invasive and expensive to the kernel, doing
hotplug on a minute basis is just plain crazy.

If you want a CPU in a keep it near and don't hand it back to the HV
state, why not use cpusets to isolate it and simply not run tasks on it?

cpusets don't use stopmachine and are much nicer to the rest of the
kernel over-all.

