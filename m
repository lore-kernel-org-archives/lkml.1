Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbYF1DM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbYF1DM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 23:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYF1DMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 23:12:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:47990 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbYF1DMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 23:12:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,718,1204531200"; 
   d="scan'208";a="300461344"
From: "Yang, Sheng" <sheng.yang@intel.com>
Organization: Intel
To: Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: [PATCH 2/2] x86: Add "virt flag" in /proc/cpuinfo
Date: Sat, 28 Jun 2008 11:12:44 +0800
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, kvm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <200806241708.49462.sheng.yang@intel.com> <200806271131.38540.sheng.yang@intel.com> <20080627145006.GA10707@volta.aurel32.net>
In-Reply-To: <20080627145006.GA10707@volta.aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806281112.44975.sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 June 2008 22:50:06 Aurelien Jarno wrote:
> On Fri, Jun 27, 2008 at 11:31:38AM +0800, Yang, Sheng wrote:
> > On Friday 27 June 2008 11:26:15 Jeremy Fitzhardinge wrote:
> > > Yang, Sheng wrote:
> > > > From 54b1bb9fe5d2fe40fc047b43dd4e1a480d41a977 Mon Sep 17
> > > > 00:00:00 2001 From: Sheng Yang <sheng.yang@intel.com>
> > > > Date: Tue, 24 Jun 2008 17:03:17 +0800
> > > > Subject: [PATCH] x86: Add "virt flag" in /proc/cpuinfo
> > > >
> > > > The hardware virtualization technology evolves very fast. But
> > > > currently it's hard to tell if your CPU support a certain
> > > > kind of HW technology without dig into the source code.
> > > >
> > > > The patch add a new item under /proc/cpuinfo, named "virt
> > > > flag". The "virt flag" got the similar function as "flag". It
> > > > is used to indicate what features does this CPU supported. It
> > > > don't cover all features but only the important ones.
> > >
> > > A cpu feature is a cpu feature.  I'd prefer to see all this in
> > > "flags:".
> > >
> > >     J
> >
> > But I think (as I said before)
> >
> > 1. The standard flag covered upper level of cpu capability, they
> > are covered by CPUID. And virt flag was enabled by vmx/svm (we
> > can leave it blank also), and covered by MSR. It's very
> > different.
> >
> > 2. If we add virtual feature to standard flag, I am afraid it
> > would grow too fast, though we just add some key feature to it.
>
> What about dumping the virtualisation flags to the kernel log when
> the vmx/svm module is loaded?
>
> Also do we have an idea of the number of flags that would appear on
> a current CPU?

I think dmesg is not so reliable...

At the time, I exported 5 flags for vmx, and 3 of them can be find in 
current CPU.

My originally patch add a attribute on sysfs for kvm. But later Avi 
suggest to use /proc/cpuinfo, for virtualization feature is becoming 
more important part of CPU. And I agreed with him.

--
Thanks
Yang, Sheng
