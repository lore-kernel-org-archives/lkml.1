Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbXJKPJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbXJKPJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbXJKPI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:08:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:32927 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbXJKPIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:08:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,260,1188802800"; 
   d="scan'208";a="169892492"
Date: Thu, 11 Oct 2007 08:08:04 -0700
From: Mark Gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, linux-pm@lists.linux-foundation.org,
       mark.gross@intel.com
Subject: Re: pm qos infrastructure and interface
Message-ID: <20071011150804.GA7293@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20071004215139.GA20078@linux.intel.com> <20071010221704.6e438c71.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071010221704.6e438c71.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2007 at 10:17:04PM -0700, Andrew Morton wrote:
> On Thu, 4 Oct 2007 14:51:39 -0700 Mark Gross <mgross@linux.intel.com> wrote:
> 
> > The following patch is a generalization of the latency.c implementation
> > done by Arjan last year.  It provides infrastructure for more than one
> > parameter, and exposes a user mode interface for processes to register
> > pm_qos expectations of processes.
> > 
> > 
> > This interface provides a kernel and user mode interface for registering
> > performance expectations by drivers, subsystems and user space
> > applications on one of the parameters.
> > 
> > Currently we have {cpu_dma_latency, network_latency, network_throughput}
> > as the initial set of pm_qos parameters.
> > 
> > The infrastructure exposes multiple misc device nodes one per
> > implemented parameter.  The set of parameters implement is defined by
> > pm_qos_power_init() and pm_qos_params.h.  This is done because having
> > the available parameters being runtime configurable or changeable from a
> > driver was seen as too easy to abuse.
> 
> I'm a bit surprised that this change appears to have no configurability.
> If one has set CONFIG_PM=n (for example), shouldn't it all go away?

We considered that as an option but as latency.c didn't offer it I
didn't either.  

I could see the user mode interface portion of the implementation be
made as a compile time option but the kernel infrastructure will
continue to be needed by at least cpu-idel, pcm_native.c and ipw2100.

You know it could make sense to have the user mode interface part of the
patch as configurable or a build time dependent of sysfs and misc device
support for the linux-tiny guys.  Is it practical to make a linux-tiny
without the sysfs infrastructure needed to make a misc device?  I'll ask
on the linux-tiny list.

--mgross
