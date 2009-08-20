Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbZHTS52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbZHTS52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 14:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZHTS51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 14:57:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:24068 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbZHTS50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 14:57:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,415,1246863600"; 
   d="scan'208";a="543281620"
Subject: Re: [PATCH] x86: add /proc/cpuinfo/physical id quirks
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alex Chiang <achiang@hp.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090819210251.GD13061@ldl.fc.hp.com>
References: <20090814163618.GQ7185@ldl.fc.hp.com>
	 <1250276831.3077.17.camel@sbs-t61.sc.intel.com>
	 <20090814192730.GA6431@ldl.fc.hp.com>
	 <1250279799.3077.41.camel@sbs-t61.sc.intel.com>
	 <20090819210251.GD13061@ldl.fc.hp.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 20 Aug 2009 11:56:33 -0700
Message-Id: <1250794594.2754.10.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 14:02 -0700, Alex Chiang wrote:
> I understand your point about keeping the output of /proc/cpuinfo
> close to what the cpuid instruction says.
> 
> But in regard to the particular field that we're talking about
> here -- 'physical id' -- that doesn't seem to be represented from
> cpuid anyway. We're stuffing an APIC ID into that field, even
> when we already have other APIC ID output.

For the current generation platforms, APIC ID's are typically from
cpuid, except for large SGI UV platforms etc.

> > For example, we shouldn't assume that original phys proc id's calculated
> > from cpuid etc need not be contiguous and start from 0 etc. This is
> > platform dependent and may vary from one version to another version of
> > processor etc.
> 
> Sorry, I'm having a hard time parsing this sentence. Do you mean
> to say:
> 
> 	we shouldn't assume that phys_proc_id calculated from
> 	cpuid are contiguous and start from 0
> 
> ?

yes.

> 
> I agree with you (although I thought that they should be 0-based)
> but this quirk addresses a specific platform, where I can assume
> certain things about the BIOS, etc.

What happens if for some reason, newer bios/newer cpu generations on
this platform start having holes in the physical id space? We can't rule
out these kind of changes and we don't want to go behind distros
requesting fixes.

> I agree with you in general, but again, this is a specific
> platform quirk where I have a good idea of what is a supported
> configuration.

I am just nervous about future bios changes etc.

> > Easiest route will be to add a new entry in /proc/cpuinfo
> 
> Well, if you remain unconvinced that fixing up 'physical id' is
> the proper thing to do, here are some alternate proposals:
> 
> 	/proc/cpuinfo/chassis id
> 	/sys/devices/system/cpu/$cpu/chassis id
> 	/sys/devices/system/cpu/$cpu/topology/chassis id
> 

I really like this alternate proposal. This is simple and straight
forward to everyone.

thanks,
suresh

