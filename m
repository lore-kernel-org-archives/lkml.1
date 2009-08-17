Return-Path: <linux-kernel-owner+w=401wt.eu-S932563AbZHQS1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbZHQS1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 14:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757956AbZHQS1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 14:27:10 -0400
Received: from mail.vyatta.com ([76.74.103.46]:42357 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646AbZHQS1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 14:27:08 -0400
Date: Mon, 17 Aug 2009 11:27:04 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: clocksource changes in 2.6.31 - possible regression
Message-ID: <20090817112704.2b4b2987@nehalam>
In-Reply-To: <1250532954.26171.35.camel@work-vm>
References: <20090817090319.20979986@nehalam>
	<1250531337.26171.12.camel@work-vm>
	<20090817110127.40ee5c29@nehalam>
	<1250532954.26171.35.camel@work-vm>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009 11:15:54 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Mon, 2009-08-17 at 11:01 -0700, Stephen Hemminger wrote:
> > On Mon, 17 Aug 2009 10:48:57 -0700
> > john stultz <johnstul@us.ibm.com> wrote:
> > 
> > > On Mon, 2009-08-17 at 09:03 -0700, Stephen Hemminger wrote:
> > > > The following commit causes a change for kernels built with HRT but
> > > > not actually using HRT.  I typically use the generic kernel we ship
> > > > on test machines, and that kernel has NOHZ and HRT (for power savings/virt
> > > > and HRT for QoS), but I want to be able to enable TSC as a clock source
> > > > when doing performance tests with pktgen.
> > > > 
> > > > The machine in question is a several year old Opteron box, that
> > > > normally reports clocksources: acpi_pm jiffies tsc
> > > > but now with 2.6.31-rc6, it only has acpi_pm.
> > > 
> > > I might need to review the patch again, but I believe we just don't
> > > allow you to switch to non HRT compatible clocksources (like jiffies) if
> > > we're already in HRT mode (and thus would hang when switched). 
> > > 
> > > 
> > > The behavior you describe where you can't switch to the TSC, may be due
> > > to the TSC disqualification code marking it as non HRT compatible
> > > (again, I need to double check). While I'm not sure that's really
> > > correct, as the TSC is fine for HRT, in this case on your box, the TSC
> > > has been marked as unstable (likely due to being unsynced on old AMD SMP
> > > systems). There is a real chance that the timekeeping code on your
> > > system could see the TSC go backwards, calculate a negative time
> > > interval, and then end up hanging. 
> > > 
> > 
> > TSC was alway stable on this box, and worked fine.  There was no
> > message in log about TSC instability. The change was bisected
> > down to that one commit.
> 
> But just to clarify, the TSC was never selected as the default
> clocksource on the box either, right?

correct.

I am okay with turning it off on boot command line for my tests,
but it might be an issue for other users.
