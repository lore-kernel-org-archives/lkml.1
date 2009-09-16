Return-Path: <linux-kernel-owner+w=401wt.eu-S1759591AbZIPQZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591AbZIPQZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZIPQZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:25:07 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:39412 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbZIPQZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:25:06 -0400
Date: Wed, 16 Sep 2009 21:54:59 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v3 0/3] cpu: pseries: Cpu offline states framework
Message-ID: <20090916162459.GB12571@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com> <1253016701.5506.73.camel@laptop> <20090916152820.GA12571@in.ibm.com> <1253115171.7180.1.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253115171.7180.1.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 05:32:51PM +0200, Peter Zijlstra wrote:
> On Wed, 2009-09-16 at 20:58 +0530, Dipankar Sarma wrote:
> > On Tue, Sep 15, 2009 at 02:11:41PM +0200, Peter Zijlstra wrote:
> > > On Tue, 2009-09-15 at 17:36 +0530, Gautham R Shenoy wrote:
> > > > This patchset contains the offline state driver implemented for
> > > > pSeries. For pSeries, we define three available_hotplug_states. They are:
> > > > 
> > > >         online: The processor is online.
> > > > 
> > > >         offline: This is the the default behaviour when the cpu is offlined
> > > > 
> > > >         inactive: This cedes the vCPU to the hypervisor with a cede latency
> > > > 
> > > > Any feedback on the patchset will be immensely valuable.
> > > 
> > > I still think its a layering violation... its the hypervisor manager
> > > that should be bothered in what state an off-lined cpu is in. 
> > 
> > The problem is that all hypervisor managers cannot figure out what sort
> > of latency guest OS can tolerate under the situation. They wouldn't know
> > from what context guest OS has ceded the vcpu. It has to have
> > some sort of hint, which is what the guest OS provides.
> 
> I'm missing something here, hot-unplug is a slow path and should not
> ever be latency critical..?

You aren't, I did :)

No, for this specific case, latency isn't an issue. The issue is -
how do we cede unused vcpus to hypervisor for better energy management ?
Yes, it can be done by a hypervisor manager telling the kernel to
offline and make a bunch of vcpus "inactive". It does have to choose
offline (release vcpu) vs. inactive (cede but guranteed if needed).
The problem is that long ago we exported a lot of hotplug stuff to
userspace through the sysfs interface and we cannot do something
inside the kernel without keeping the sysfs stuff consistent.
This seems like a sane way to do that without undoing all the
virtual cpu hotplug infrastructure in different supporting archs.

Thanks
Dipankar
