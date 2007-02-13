Return-Path: <linux-kernel-owner+w=401wt.eu-S1750733AbXBMOFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750733AbXBMOFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbXBMOFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:05:32 -0500
Received: from mga06.intel.com ([134.134.136.21]:37185 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750733AbXBMOFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:05:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,163,1170662400"; 
   d="scan'208"; a="196204592:sNHT18629037"
Date: Tue, 13 Feb 2007 05:31:16 -0800
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Dave Jones <davej@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Adam Belay <abelay@novell.com>,
       Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 1/3] Introducing cpuidle: core cpuidle infrastructure
Message-ID: <20070213053116.A13596@unix-os.sc.intel.com>
References: <20070212103925.A12078@unix-os.sc.intel.com> <20070213012201.GA27685@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <20070213012201.GA27685@redhat.com>; from davej@redhat.com on Mon, Feb 12, 2007 at 08:22:01PM -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 08:22:01PM -0500, Dave Jones wrote:
> On Mon, Feb 12, 2007 at 10:39:25AM -0800, Venkatesh Pallipadi wrote:
>  > 
>  > Introducing 'cpuidle', a new CPU power management infrastructure to manage
>  > idle CPUs in a clean and efficient manner.
>  > cpuidle separates out the drivers that can provide support for multiple types
>  > of idle states and policy governors that decide on what idle state to use
>  > at run time.
>  > A cpuidle driver can support multiple idle states based on parameters like
>  > varying power consumption, wakeup latency, etc (ACPI C-states for example).
>  > A cpuidle governor can be usage model specific (laptop, server,
>  > laptop on battery etc).
>  > Main advantage of the infrastructure being, it allows independent development
>  > of drivers and governors and allows for better CPU power management.
>  > 
>  > A huge thanks to Adam Belay and Shaohua Li who were part of this mini-project
>  > since its beginning and are greatly responsible for this patchset.
> 
> interesting.  Though I wonder about giving admins _more_ knobs to twiddle.
> It took cpufreq a long time to settle down in this area, and typically
> 'ondemand' was the answer in the end for 99.9% of people.   I question the usefulness
> for the whole multiple governors interface, because in the case of cpuidle
> there shouldn't be any real trade-off between one algorithm and another afaics?
> So why can't we just have one, that just 'does the right thing' ?
> The only differentiator that I can think of would be latency, but that seems
> to be a) covered in a different tunable, and b) probably wouldn't affect
> most people enough where it matters.
> 

Agreed. In long term, I think cpuidle will also have one governor that will be
used in most of the cases. But, we have to go through the process of
experimenting with different governors, just like cpufreq and let the best
governor win. I think this interface helps to experiment with new
governors in a non-disruptive way. I mean, any new experiments will not have
side effects on people already using currently established drivers in
distributions.

Also, one of the things we are looking at is to have ratings for different
drivers and governors (similar to time subsystem), with which we can control
best driver and best governor for a platform from inside the kernel, instead
of depending on admin/init script to do the right thing.

Having said that, I do feel we may need a different governor for things like
handhelds. I heard them saying there idle routines has more than one
dimension of low power-high latency idle states. But, that do not suggest the
need for runtime switch in sysfs, as it will still be one proper governor for
a platform.

> I'll do a proper code review later, but one thing stuck out like a sore
> thumb on a quick skim..
> 
> 
>  > +EXPORT_SYMBOL_GPL(current_driver);
> That's a horribly generic name for an exported global.
> 
> current_cpuidle_driver maybe?
> 

oops. I don't think we need to export here.
Though, name should change to current_cpuidle_driver as it is non-static. Will
fix it in next rev. 

Thanks,
Venki
