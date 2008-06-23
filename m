Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYFWJrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYFWJrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 05:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYFWJq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 05:46:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:59856 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbYFWJqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 05:46:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,689,1204531200"; 
   d="scan'208";a="344526339"
From: "Yang, Sheng" <sheng.yang@intel.com>
Organization: Intel
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH 1/4] KVM: Report hardware virtualization features
Date: Mon, 23 Jun 2008 17:47:07 +0800
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: dor.laor@qumranet.com, kvm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <200806191842.56275.sheng.yang@intel.com> <485F0D21.1000708@qumranet.com> <200806231101.13399.sheng.yang@intel.com>
In-Reply-To: <200806231101.13399.sheng.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231747.07773.sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008 11:01:13 Yang, Sheng wrote:
> On Monday 23 June 2008 10:40:33 Avi Kivity wrote:
> > Yang, Sheng wrote:
> > > On Sunday 22 June 2008 20:21:37 Avi Kivity wrote:
> > >> Dor Laor wrote:
> > >>>> Yes, this is definitely helpful.  However, I think that users will
> > >>>> expect cpu flags under /proc/cpuinfo.
> > >>>>
> > >>>> Perhaps we should add a new line 'virt flags' to /proc/cpuinfo?  I
> > >>>> think all the features are reported using msrs, so it can be done
> > >>>> from arch/x86/kernel/cpu/proc.c without involving kvm at all.
> > >>>
> > >>> while I agree with Avi, it would be nice thought to see them on older
> > >>> kernels. At least sprinkle a printk message.
> > >>
> > >> Oh we'll certainly hack something for the external modules.
> > >
> > > Yeah, add a virt flags is more directly, and I think it's not hard to
> > > be accepted. I will do that.
> >
> > Perhaps just adding to the standard flags line is best, since tools
> > already read it.
>
> I was thinking of it before, but later I think it's not very proper.
> 1. The standard flag covered upper level of cpu capability.
> 2. If we add virtual feature to standard flag, I am afraid it would grow
> too fast.
>
> So I prefer to add a new "virt flag".
>
> > > And as Dor said, I think we also need a relative elegant method for the
> > > modules. So maybe we can keep these patches? Without that bash script.
> > > :)
> >
> > I'll just copy the code that finally makes it and put it in
> > kernel/external-module-compat.c.  Patches would stop applying soon.
>
> You means the current patchset or patch for /proc/cpuinfo? :)
>

One of my colleague said that if we modify /proc/cpuinfo, it may cause some 
trouble for some not well designed userspace parser... So he thought we 
should be careful about modify this interface.

Add flag to standard flags can avoid this, but I still think it make some 
different things mixture...

Maybe we should contact some guy on X86 side?

--
Thanks
Yang, Sheng
