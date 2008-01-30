Return-Path: <linux-kernel-owner+w=401wt.eu-S1762033AbYA3KYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762033AbYA3KYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761452AbYA3KXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:23:08 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:35063 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760301AbYA3KXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:23:04 -0500
Date: Wed, 30 Jan 2008 02:22:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: Luotao Fu <l.fu@pengutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc - RCU issue?
Message-ID: <20080130102255.GA24890@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1200544050.318.18.camel@localhost.localdomain> <478F2A46.5070506@grandegger.com> <20080123145340.GE6200@pengutronix.de> <47976D06.1010900@grandegger.com> <479DF0A1.3000906@pengutronix.de> <479DF711.5090406@grandegger.com> <479F186A.4020004@pengutronix.de> <479F2C3C.1020203@grandegger.com> <20080130010716.GB16069@linux.vnet.ibm.com> <47A032E9.4080105@grandegger.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A032E9.4080105@grandegger.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 09:18:49AM +0100, Wolfgang Grandegger wrote:
> Paul E. McKenney wrote:
> > On Tue, Jan 29, 2008 at 02:38:04PM +0100, Wolfgang Grandegger wrote:
> >> Luotao Fu wrote:
> >>> Hi,
> >>>
> >>> Wolfgang Grandegger wrote:
> >>> ..........
> >>>> Do you still get high latencies with:
> >>>>
> >>>>   CONFIG_PREEMPT_RCU_BOOST=y
> >>>>   CONFIG_RCU_TRACE=y
> >>>>   CONFIG_NO_HZ is not set
> >>>>
> >>>> With this setting I have not yet realized latencies > 150us. Could you
> >>>> please give it a try? If I change one of the parameters above, latency
> >>>> increases in short time.
> >>> I played through some combination of the RCU options and can back your
> >>> observation this time: With the rcu Tracer or the priority boost turned
> >>> off I also could measure reliably extraordinory high latencies. If they
> >>> are both turned on, no high latencies could be measured. Turning on the
> >>> dynamic ticker however doesn't seem to cause high latencies during my
> >>> test runs. Seemed like an rcu issue here.
> >> I'm just making a long test run on my TQM5200 module with my good
> >> settings. After more than 4.5 hours under load, cyclictest shows a
> >> maximum latency of 177 us. I'm going to re-check the effect of CONFIG_NO_HZ.
> >>
> >>> Further such results only appear if the target board is booted with
> >>> nfsrootfs. (As I already have mentioned several times before), which
> >>> leads my suspection to rcu usage in nfs implementation. In this case
> >>> this problem might even be platformindependent. I'd have to do some
> >>> tests on one of our arm boards later to test this. Since there're no
> >>> reports like this for other architecture as powerpc till now, I doubt
> >>> quite if this is verifiable.
> >> It's also my suspicion that the high latencies are related to the RCU
> >> usage in the network layer, where it's heavily used. What is really
> >> wired is that switching off CONFIG_RCU_TRACE has a negative impact on
> >> the latency. As I see it, it just adds some trace points, but I might
> >> have missed something.
> > 
> > I would expect that CONFIG_RCU_TRACE=n (as in "no" rather than "module")
> > would have low latencies rather than high latencies.  So I am quite
> > surprised by your result.  I will dig into this more.
> 
> Thanks a lot. To be clear. I need "CONFIG_PREEMPT_RCU_BOOST=y" *and*
> "CONFIG_RCU_TRACE=y" to achieve reasonable latencies below 180us. With
> CONFIG_PREEMPT_RCU_BOOST or CONFIG_RCU_TRACE not set or
> CONFIG_RCU_TRACE=m is rmeasure latencies up to 600us within a minute or so.

OK, thank you for the confirmation.

The large latencies were from cyclictest, correct?  Did other tests
also show these latencies?  In either case, could you please send the
exact command line you used to run the test?

							Thanx, Paul
