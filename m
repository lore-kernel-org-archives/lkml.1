Return-Path: <linux-kernel-owner+w=401wt.eu-S932676AbZHQSQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676AbZHQSQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 14:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757896AbZHQSQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 14:16:13 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38291 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844AbZHQSQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 14:16:13 -0400
Subject: Re: clocksource changes in 2.6.31 - possible regression
From: john stultz <johnstul@us.ibm.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20090817110127.40ee5c29@nehalam>
References: <20090817090319.20979986@nehalam>
	 <1250531337.26171.12.camel@work-vm>  <20090817110127.40ee5c29@nehalam>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 11:15:54 -0700
Message-Id: <1250532954.26171.35.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 11:01 -0700, Stephen Hemminger wrote:
> On Mon, 17 Aug 2009 10:48:57 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> 
> > On Mon, 2009-08-17 at 09:03 -0700, Stephen Hemminger wrote:
> > > The following commit causes a change for kernels built with HRT but
> > > not actually using HRT.  I typically use the generic kernel we ship
> > > on test machines, and that kernel has NOHZ and HRT (for power savings/virt
> > > and HRT for QoS), but I want to be able to enable TSC as a clock source
> > > when doing performance tests with pktgen.
> > > 
> > > The machine in question is a several year old Opteron box, that
> > > normally reports clocksources: acpi_pm jiffies tsc
> > > but now with 2.6.31-rc6, it only has acpi_pm.
> > 
> > I might need to review the patch again, but I believe we just don't
> > allow you to switch to non HRT compatible clocksources (like jiffies) if
> > we're already in HRT mode (and thus would hang when switched). 
> > 
> > 
> > The behavior you describe where you can't switch to the TSC, may be due
> > to the TSC disqualification code marking it as non HRT compatible
> > (again, I need to double check). While I'm not sure that's really
> > correct, as the TSC is fine for HRT, in this case on your box, the TSC
> > has been marked as unstable (likely due to being unsynced on old AMD SMP
> > systems). There is a real chance that the timekeeping code on your
> > system could see the TSC go backwards, calculate a negative time
> > interval, and then end up hanging. 
> > 
> 
> TSC was alway stable on this box, and worked fine.  There was no
> message in log about TSC instability. The change was bisected
> down to that one commit.

But just to clarify, the TSC was never selected as the default
clocksource on the box either, right?

thanks
-john


