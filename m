Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbZIYVPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbZIYVPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 17:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZIYVPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 17:15:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:41032 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbZIYVPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 17:15:11 -0400
Subject: Re: [PATCH v3 0/3] cpu: pseries: Cpu offline states framework
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <1253890120.18939.189.camel@laptop>
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
	 <1253016701.5506.73.camel@laptop>  <1253753501.7103.358.camel@pasglop>
	 <1253890120.18939.189.camel@laptop>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 07:12:48 +1000
Message-Id: <1253913169.7103.529.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 16:48 +0200, Peter Zijlstra wrote:
> On Thu, 2009-09-24 at 10:51 +1000, Benjamin Herrenschmidt wrote:
> > On Tue, 2009-09-15 at 14:11 +0200, Peter Zijlstra wrote:
> > > I still think its a layering violation... its the hypervisor manager
> > > that should be bothered in what state an off-lined cpu is in. 
> > > 
> > That's not how our hypervisor works.
> 
> Then fix it?

Are you serious ? :-)

> CPU hotplug is terribly invasive and expensive to the kernel, doing
> hotplug on a minute basis is just plain crazy.
> 
> If you want a CPU in a keep it near and don't hand it back to the HV
> state, why not use cpusets to isolate it and simply not run tasks on it?
> 
> cpusets don't use stopmachine and are much nicer to the rest of the
> kernel over-all.

Gautham, what is the different in term of power saving between having
it idle for long periods of time (which could do H_CEDE and with NO_HZ,
probably wouln't need to wake up that often) and having it unplugged in
a H_CEDE loop ?

Ben.



