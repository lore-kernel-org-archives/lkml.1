Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757Ab0A2IMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab0A2IMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 03:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471Ab0A2IMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 03:12:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38735 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0A2IMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 03:12:48 -0500
Date: Fri, 29 Jan 2010 09:12:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [RFC] nmi_watchdog: config option to enable new
 nmi_watchdog
Message-ID: <20100129081227.GK14636@elte.hu>
References: <1264622622-5778-1-git-send-email-dzickus@redhat.com>
 <1264622622-5778-4-git-send-email-dzickus@redhat.com>
 <1264690494.4283.2103.camel@laptop>
 <20100128154448.GV4472@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100128154448.GV4472@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Thu, Jan 28, 2010 at 03:54:54PM +0100, Peter Zijlstra wrote:
> > On Wed, 2010-01-27 at 15:03 -0500, Don Zickus wrote:
> > > These are the bits that enable the new nmi_watchdog and safely isolate the
> > > old nmi_watchdog.  Only one or the other can run, not both at the same
> > > time.
> > 
> > perf disables the lapic watchdog when it wants the pmu, so there
> > shouldn't be a problem having both built in.
> 
> Yes it does disable but does not prevent nmi_watchdog_tick from running nor 
> the /proc interface from being loaded.  So perhaps my description isn't very 
> good.  The idea with the new watchdog was to re-use some of the bits of the 
> old one, but having them both compiled in seemed to stomp on each other.  
> That is what I was trying to prevent.
> 
> I can certainly change the behaviour, just makes the code a little more 
> messy I think.

I think that's a good idea - and i think we want to be bold and just have the 
new code run seemlessly. (and fix bugs, if any.)

In fact we want to be even bolder: how about enabling the NMI watchdog by 
default again?

The problem with the old one was its fragility - but now if we have a PMU 
driver active and perf events enabled we might as well use your brand new NMI 
watchdog code as a testing facility as well: if there's _any_ problem with 
NMIs then regular 'perf' use would trigger it too - except that not all people 
run perf while an always-enabled NMI watchdog would.

And it would detect hard hangs too.

What do you think?

	Ingo
