Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbZIQI7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbZIQI7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 04:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbZIQI7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 04:59:51 -0400
Received: from mga06.intel.com ([134.134.136.21]:13533 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752152AbZIQI7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 04:59:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,402,1249282800"; 
   d="scan'208";a="551358685"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [RFC][PATCH 0/10] Xen Hybrid extension support
Date: Thu, 17 Sep 2009 16:59:47 +0800
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; x86_64; ; )
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "xen-devel" <xen-devel@lists.xensource.com>,
       Eddie Dong <eddie.dong@intel.com>, linux-kernel@vger.kernel.org,
       Jun Nakajima <jun.nakajima@intel.com>
References: <1253090551-7969-1-git-send-email-sheng@linux.intel.com> <20090916133104.GB14725@phenom.dumpdata.com>
In-Reply-To: <20090916133104.GB14725@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909171659.48569.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 September 2009 21:31:04 Konrad Rzeszutek Wilk wrote:
> On Wed, Sep 16, 2009 at 04:42:21PM +0800, Sheng Yang wrote:
> > Hi, Keir & Jeremy
> >
> > This patchset enabled Xen Hybrid extension support.
> >
> > As we know that PV guest have performance issue with x86_64 that guest
> > kernel and userspace resistent in the same ring, then the necessary TLB
> > flushes when switch between guest userspace and guest kernel cause
> > overhead, and much more syscall overhead is also introduced. The Hybrid
> > Extension estimated these overhead by putting guest kernel back in
> > (non-root) ring0 then achieve the better performance than PV guest.
>
> What was the overhead? Is there a step-by-step list of operations you did
> to figure out the performance numbers?

The overhead I mentioned is, in x86_64 pv guest, every syscall would be goes 
to hypervisor first, then hypervisor transmit it to guest kernel, finally 
guest kernel goes back to guest userspace. Due to the involvement of 
hypervisor, there is certainly overhead. And every transition result in TLB 
flush. In 32bit pv guest, guest use #int82 to emulate syscall, which can 
specific the privilege level, so that hypervisor don't need involve. 

And sorry, I don't have a step-by-step list for the performance tunning. All 
above is a known issue of x86_64 pv guest.
>
> I am asking this b/c at some point I would like to compare the pv-ops vs
> native and I am not entirely sure what is the best way to do this.

Sorry, I don't have much advise on this. If you means tuning, what I can 
purposed is just running some microbenchmark(lmbench is a favor of mine), 
collect (guest) hot function with xenoprofile and compare the result of native 
and pv-ops to figure out the gap...

-- 
regards
Yang, Sheng
