Return-Path: <linux-kernel-owner+w=401wt.eu-S1751820AbZI1Nx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbZI1Nx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 09:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbZI1Nx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 09:53:58 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:34206 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZI1Nx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 09:53:58 -0400
Date: Mon, 28 Sep 2009 19:23:44 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v3 0/3] cpu: pseries: Cpu offline states framework
Message-ID: <20090928135344.GK8595@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
 <1253016701.5506.73.camel@laptop>
 <1253753501.7103.358.camel@pasglop>
 <1253890120.18939.189.camel@laptop>
 <1253913169.7103.529.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1253913169.7103.529.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt <benh@kernel.crashing.org> [2009-09-26 07:12:48]:

> On Fri, 2009-09-25 at 16:48 +0200, Peter Zijlstra wrote:
> > On Thu, 2009-09-24 at 10:51 +1000, Benjamin Herrenschmidt wrote:
> > > On Tue, 2009-09-15 at 14:11 +0200, Peter Zijlstra wrote:
> > > > I still think its a layering violation... its the hypervisor manager
> > > > that should be bothered in what state an off-lined cpu is in. 
> > > > 
> > > That's not how our hypervisor works.
> > 
> > Then fix it?
> 
> Are you serious ? :-)
> 
> > CPU hotplug is terribly invasive and expensive to the kernel, doing
> > hotplug on a minute basis is just plain crazy.
> > 
> > If you want a CPU in a keep it near and don't hand it back to the HV
> > state, why not use cpusets to isolate it and simply not run tasks on it?
> > 
> > cpusets don't use stopmachine and are much nicer to the rest of the
> > kernel over-all.
> 
> Gautham, what is the different in term of power saving between having
> it idle for long periods of time (which could do H_CEDE and with NO_HZ,
> probably wouln't need to wake up that often) and having it unplugged in
> a H_CEDE loop ?

Hi Ben,

A cede latency specifier value indicating latency expectation of the
guest OS can be established in the VPA to inform the hypervisor during
the H_CEDE call.  Currently, we do call H_CEDE during NO_HZ for
efficient idle.  However, higher cede latency values may not be
suitable for idle CPUs in the kernel and instead more energy savings
may result from exploiting this feature through CPU hotplug
interface.

--Vaidy
