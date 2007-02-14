Return-Path: <linux-kernel-owner+w=401wt.eu-S932262AbXBNEDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbXBNEDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 23:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbXBNEDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 23:03:08 -0500
Received: from peabody.ximian.com ([130.57.169.10]:60575 "EHLO
	peabody.ximian.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbXBNEDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 23:03:07 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Feb 2007 23:03:07 EST
Subject: Re: [PATCH 1/3] Introducing cpuidle: core cpuidle infrastructure
From: Adam Belay <abelay@novell.com>
To: Dave Jones <davej@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>
In-Reply-To: <20070213053116.A13596@unix-os.sc.intel.com>
References: <20070212103925.A12078@unix-os.sc.intel.com>
	 <20070213012201.GA27685@redhat.com>
	 <20070213053116.A13596@unix-os.sc.intel.com>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 23:10:43 -0500
Message-Id: <1171426244.5961.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 05:31 -0800, Venkatesh Pallipadi wrote:
> On Mon, Feb 12, 2007 at 08:22:01PM -0500, Dave Jones wrote:
> > On Mon, Feb 12, 2007 at 10:39:25AM -0800, Venkatesh Pallipadi wrote:
> >  > 
> >  > Introducing 'cpuidle', a new CPU power management infrastructure to manage
> >  > idle CPUs in a clean and efficient manner.
> >  > cpuidle separates out the drivers that can provide support for multiple types
> >  > of idle states and policy governors that decide on what idle state to use
> >  > at run time.
> >  > A cpuidle driver can support multiple idle states based on parameters like
> >  > varying power consumption, wakeup latency, etc (ACPI C-states for example).
> >  > A cpuidle governor can be usage model specific (laptop, server,
> >  > laptop on battery etc).
> >  > Main advantage of the infrastructure being, it allows independent development
> >  > of drivers and governors and allows for better CPU power management.
> >  > 
> >  > A huge thanks to Adam Belay and Shaohua Li who were part of this mini-project
> >  > since its beginning and are greatly responsible for this patchset.
> > 
> > interesting.  Though I wonder about giving admins _more_ knobs to twiddle.
> > It took cpufreq a long time to settle down in this area, and typically
> > 'ondemand' was the answer in the end for 99.9% of people.   I question the usefulness
> > for the whole multiple governors interface, because in the case of cpuidle
> > there shouldn't be any real trade-off between one algorithm and another afaics?
> > So why can't we just have one, that just 'does the right thing' ?
> > The only differentiator that I can think of would be latency, but that seems
> > to be a) covered in a different tunable, and b) probably wouldn't affect
> > most people enough where it matters.
> > 
> 
> Agreed. In long term, I think cpuidle will also have one governor that will be
> used in most of the cases. But, we have to go through the process of
> experimenting with different governors, just like cpufreq and let the best
> governor win. I think this interface helps to experiment with new
> governors in a non-disruptive way. I mean, any new experiments will not have
> side effects on people already using currently established drivers in
> distributions.
> 
> Also, one of the things we are looking at is to have ratings for different
> drivers and governors (similar to time subsystem), with which we can control
> best driver and best governor for a platform from inside the kernel, instead
> of depending on admin/init script to do the right thing.
> 
> Having said that, I do feel we may need a different governor for things like
> handhelds. I heard them saying there idle routines has more than one
> dimension of low power-high latency idle states. But, that do not suggest the
> need for runtime switch in sysfs, as it will still be one proper governor for
> a platform.

Learning from the past, I think a good comparison would be the support
for several block IO schedulers (e.g. deadline, cfq, anticipatory, etc).
The added flexibility of a pluggable architecture allowed for a lot of
innovation and experimentation that might not have happened otherwise.
There even is a "noop" scheduler that makes sense for some hardware
devices but not others.  In short, Linux processor idle power management
support needs some growing room to find its "ondemand" equivalent.

In my opinion, the best sort of a tunable would be a variable that
indicates userspace's intentions to the cpuidle governor.  Maybe
something to the effect of the following...
- Maximum Performance
- Balanced (attempt to do well in both)
- Maximum Battery-life

Of course governors can have their own specific tunables, but it would
probably be best to not touch them in the typical use-case.

Thanks,
Adam


