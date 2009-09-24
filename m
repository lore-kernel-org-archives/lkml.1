Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbZIXA5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbZIXA5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbZIXA5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:57:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:52473 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbZIXA5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:57:35 -0400
Subject: Re: [PATCH v3 0/3] cpu: pseries: Cpu offline states framework
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: dipankar@in.ibm.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <20090916162459.GB12571@in.ibm.com>
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
	 <1253016701.5506.73.camel@laptop> <20090916152820.GA12571@in.ibm.com>
	 <1253115171.7180.1.camel@laptop>  <20090916162459.GB12571@in.ibm.com>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 10:55:14 +1000
Message-Id: <1253753715.7103.361.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 21:54 +0530, Dipankar Sarma wrote:
> You aren't, I did :)
> 
> No, for this specific case, latency isn't an issue. The issue is -
> how do we cede unused vcpus to hypervisor for better energy
> management ?
> Yes, it can be done by a hypervisor manager telling the kernel to
> offline and make a bunch of vcpus "inactive". It does have to choose
> offline (release vcpu) vs. inactive (cede but guranteed if needed).
> The problem is that long ago we exported a lot of hotplug stuff to
> userspace through the sysfs interface and we cannot do something
> inside the kernel without keeping the sysfs stuff consistent.
> This seems like a sane way to do that without undoing all the
> virtual cpu hotplug infrastructure in different supporting archs.
> 
Well, I did bring the latency into the picture. To some extent it -is- a
latency issue. Though we aren't talking milliseconds here... if the
CPU's been reallocated to another partition we are talking seconds or
minutes or more until we can get it back :-)

In any case, this sounds to me like a perfectly valid feature to have,
which s390 already does via arch specific hooks, so I fail to see why it
wouldn't be legitimate to have a common attribute for it.

I don't buy into the layering violation. It's too often a straw man and
an excuse for a lack of a proper reason.

Cheers,
Ben.

