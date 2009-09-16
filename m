Return-Path: <linux-kernel-owner+w=401wt.eu-S1759840AbZIPRDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840AbZIPRDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 13:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbZIPRD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 13:03:29 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:50735 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbZIPRD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 13:03:28 -0400
Date: Wed, 16 Sep 2009 22:33:14 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: dipankar@in.ibm.com, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v3 0/3] cpu: pseries: Cpu offline states framework
Message-ID: <20090916170314.GH15538@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
 <1253016701.5506.73.camel@laptop>
 <20090916152820.GA12571@in.ibm.com>
 <1253115171.7180.1.camel@laptop>
 <20090916162459.GB12571@in.ibm.com>
 <1253118916.7180.6.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1253118916.7180.6.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-09-16 18:35:16]:

> On Wed, 2009-09-16 at 21:54 +0530, Dipankar Sarma wrote:
> 
> > No, for this specific case, latency isn't an issue. The issue is -
> > how do we cede unused vcpus to hypervisor for better energy management ?
> > Yes, it can be done by a hypervisor manager telling the kernel to
> > offline and make a bunch of vcpus "inactive". It does have to choose
> > offline (release vcpu) vs. inactive (cede but guranteed if needed).
> > The problem is that long ago we exported a lot of hotplug stuff to
> > userspace through the sysfs interface and we cannot do something
> > inside the kernel without keeping the sysfs stuff consistent.
> > This seems like a sane way to do that without undoing all the
> > virtual cpu hotplug infrastructure in different supporting archs.
> 
> I'm still not getting it..
> 
> Suppose we have some guest, it booted with 4 cpus.
> 
> We then offline 2 of them.
> 
> Apparently this LPAR binds guest cpus to physical cpus?
> So we use a hypervisor interface to reclaim these 2 offlined cpus and
> re-assign them to some other guest.
> 
> So far so good, right?
> 
> Now if you were to try and online the cpus in the guest, it'd fail
> because the cpus aren't backed anymore, and the hot-plug simply
> times-out and fails.
> 
> And we're still good, right?

The requirement differ here.  If we had offlined 2 vCPUs for the
purpose of system reconfiguration, the expected behavior with offline
interface will work right.  However the proposed cede interface is
needed when we want them to temporarily go away but still come back
when we do an online.  We want the online to always succeed since the
backing physical resources are not relinquished.  The proposed
interface facilitates offline without relinquishing the physical
resources assigned to LPARs.

--Vaidy

