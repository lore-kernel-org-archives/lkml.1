Return-Path: <linux-kernel-owner+w=401wt.eu-S1762942AbZFQHdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762942AbZFQHdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZFQHc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:32:56 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:22612 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbZFQHcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:32:55 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFD PATCH 0/4] cpu: Bulk CPU Hotplug support.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: svaidy@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@in.ibm.com>, Rusty Russel <rusty@rustcorp.com.au>,
       Paul E McKenney <paulmck@us.ibm.com>, Nathan Lynch <ntl@pobox.com>,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
In-Reply-To: <20090616080715.GB7961@dirshya.in.ibm.com>
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
	 <20090615232318.74b099a6.akpm@linux-foundation.org>
	 <20090616080715.GB7961@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 09:32:57 +0200
Message-Id: <1245223977.13761.21576.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 13:37 +0530, Vaidyanathan Srinivasan wrote:
> * Andrew Morton <akpm@linux-foundation.org> [2009-06-15 23:23:18]:
> 
> > On Tue, 16 Jun 2009 11:08:39 +0530 Gautham R Shenoy <ego@in.ibm.com> wrote:
> > 
> > > Currently on a ppc64 box with 16 CPUs, the time taken for
> > > a individual cpu-hotplug operation is as follows.
> > > 
> > >     # time echo 0 > /sys/devices/system/cpu/cpu2/online
> > >     real    0m0.025s
> > >     user    0m0.000s
> > >     sys     0m0.002s
> > > 
> > >     # time echo 1 > /sys/devices/system/cpu/cpu2/online
> > >     real    0m0.021s
> > >     user    0m0.000s
> > >     sys     0m0.000s
> > 
> > Surprised.  Do people really online and offline CPUs frequently enough
> > for this to be a problem?
> 
> Certainly not for hardware faults or hardware replacement, but
> cpu-hotplug interface is useful for changing system configuration to
> meet different objectives like
> 
> * Reduce system capacity to reduce average power and reduce heat
> 
> * Increasing number of cores and threads in a CPU package is leading
>   to multiple cpu offline/online operations for any perceivable effect
> 
> * Dynamically change CPU configurations in virtualized environments

I tend to agree with Andrew, if any of those things are done frequent
enough that the hotplug performance matter you're doing something mighty
odd.

