Return-Path: <linux-kernel-owner+w=401wt.eu-S1750994AbZHSBFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbZHSBFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 21:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbZHSBFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 21:05:41 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60899 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZHSBFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 21:05:40 -0400
Subject: Re: [PATCH] make tsc=reliable override boot time stability checks
From: john stultz <johnstul@us.ibm.com>
To: akataria@vmware.com
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1250559540.32479.45.camel@ank32.eng.vmware.com>
References: <20090817090319.20979986@nehalam>
	 <1250531337.26171.12.camel@work-vm>	<20090817110127.40ee5c29@nehalam>
	 <1250532954.26171.35.camel@work-vm>	<20090817112704.2b4b2987@nehalam>
	 <1250543459.7212.41.camel@localhost.localdomain>
	 <1250545077.7212.49.camel@localhost.localdomain>
	 <20090817144546.7f1d6572@nehalam>
	 <1250547802.7212.82.camel@localhost.localdomain>
	 <20090817160212.029b3e42@nehalam>
	 <1250551074.7212.84.camel@localhost.localdomain>
	 <20090817162729.451613b4@nehalam>
	 <1250552447.7212.92.camel@localhost.localdomain>
	 <1250559540.32479.45.camel@ank32.eng.vmware.com>
Content-Type: text/plain
Date: Tue, 18 Aug 2009 18:04:31 -0700
Message-Id: <1250643871.7002.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 18:39 -0700, Alok Kataria wrote:
> Hi John,
> 
> On Mon, 2009-08-17 at 16:40 -0700, john stultz wrote:
> > On Mon, 2009-08-17 at 16:27 -0700, Stephen Hemminger wrote:
> > > On Mon, 17 Aug 2009 16:17:54 -0700
> > > john stultz <johnstul@us.ibm.com> wrote:
> > > 
> > > > On Mon, 2009-08-17 at 16:02 -0700, Stephen Hemminger wrote:
> > > > > This adds tsc, but makes it first?  it is reliable, but do I want
> > > > > to make it most important?
> > > > > 
> > > > > $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> > > > > tsc acpi_pm
> > > > 
> > > > 
> > > > Well, if you're overriding the system saying that its safe, then sure,
> > > > its better then anything else, why wouldn't we?
> > > > 
> > > 
> > > That's acceptable, maybe add change to Documentation/kernel-parameters.txt
> > > 
> > > 	tsc=		Disable clocksource-must-verify flag for TSC.
> > > 			Format: <string>
> > > 			[x86] reliable: mark tsc clocksource as reliable and
> > >                         makes tsc the default clocksource; this
> > > 			disables clocksource verification at runtime.
> > > 			Used to enable high-resolution timer mode on older
> > > 			hardware, and in virtualized environment.
> > > 
> > 
> > Sounds good. Thanks so much for the bug report and testing!
> > 
> > 
> > This patch makes the tsc=reliable option disable the boot time stability
> > checks. Currently the option only disables the runtime watchdog checks.
> > This change allows folks who want to override the boot time TSC
> > stability checks and use the TSC when the system would otherwise
> > disqualify it.
> > 
> > There still are some situations that the TSC will be disqualified, such
> > as cpufreq scaling. But these are situations where the box will hang if
> > allowed.
> > 
> 
> I had purposefully kept the tsc=reliable separate from the TSC
> synchronous checks. 
> With this patch TSC is marked as usable though the hardware below
> doesn't export a CONSTANT_TSC, it might not be a problem generally, but
> since TSC has the highest rating, don't you think that timekeeping might
> be wayward on such systems ? 

Oh yea, there's a risk of that, but we are telling the kernel to
override its runtime checking of the clocksource, so it seems reasonable
to also include the boot time checks. I worry otherwise the option
becomes too subtle to be really useful to users. 

> Having said that, I don't think I have a particular problem with the
> patch as far as we are explicitly mentioning the fact that TSC=reliable
> means TSC is blindly trusted on this system, and time might be little
> off on some systems.

I think the explicit boot option, along with the kernel-parameters text
makes it clear enough, but if you have a specific wording in mind that
works better, please send a patch and I'll ack it.

thanks
-john

