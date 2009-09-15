Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbZIOO6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbZIOO6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 10:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbZIOO6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 10:58:39 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:50145 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbZIOO6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 10:58:38 -0400
Date: Tue, 15 Sep 2009 20:28:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v3 0/3] cpu: pseries: Cpu offline states framework
Message-ID: <20090915145834.GG4846@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
 <1253016701.5506.73.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1253016701.5506.73.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-09-15 14:11:41]:

> On Tue, 2009-09-15 at 17:36 +0530, Gautham R Shenoy wrote:
> > This patchset contains the offline state driver implemented for
> > pSeries. For pSeries, we define three available_hotplug_states. They are:
> > 
> >         online: The processor is online.
> > 
> >         offline: This is the the default behaviour when the cpu is offlined
> >         even in the absense of this driver. The CPU would call make an
> >         rtas_stop_self() call and hand over the CPU back to the resource pool,
> >         thereby effectively deallocating that vCPU from the LPAR.
> >         NOTE: This would result in a configuration change to the LPAR
> >         which is visible to the outside world.
> > 
> >         inactive: This cedes the vCPU to the hypervisor with a cede latency
> >         specifier value 2.
> >         NOTE: This option does not result in a configuration change
> >         and the vCPU would be still entitled to the LPAR to which it earlier
> >         belong to.
> > 
> > Any feedback on the patchset will be immensely valuable.
> 
> I still think its a layering violation... its the hypervisor manager
> that should be bothered in what state an off-lined cpu is in. 
>

>From a design standpoint where we stand today is

1. A cede indicates that the CPU is no longer needed and can be
reassigned (remember we do dedicated CPU partitions in power)
2. What this patch is trying to do is to say "We don't need the
CPU, but please don't reassign, put it to sleep"

We work the same way with the hypervisor, that applications work with
the OS today, by providing madvise and other hints.

-- 
	Balbir
