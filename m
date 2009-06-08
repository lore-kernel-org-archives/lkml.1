Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZFHNrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZFHNrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbZFHNq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:46:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37603 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbZFHNqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:46:55 -0400
Date: Mon, 8 Jun 2009 15:46:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: Run-time PM idea (was: Re: [linux-pm] [RFC][PATCH 0/2] PM:
	Rearrange core suspend code)
Message-ID: <20090608134647.GA14234@elte.hu>
References: <Pine.LNX.4.44L0.0906071651060.25203-100000@netrider.rowland.org> <200906072347.00580.rjw@sisk.pl> <20090608065419.GA13568@elte.hu> <200906081330.50045.rjw@sisk.pl> <20090608130509.GA3272@elte.hu> <20090608131159.GA15100@srcf.ucam.org> <20090608132235.GC13214@elte.hu> <20090608133215.GA15482@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608133215.GA15482@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Mon, Jun 08, 2009 at 03:22:35PM +0200, Ingo Molnar wrote:
> > 
> > * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > > The difficulty is in determining when it's viable to autosuspend a 
> > > given device. There's a limit to how much we can determine purely 
> > > from kernel state (for instance, we could suspend ahci when 
> > > there's no pending disk access, but we'd lose hotplug 
> > > notifications) so there's going to have to be some level of 
> > > userspace policy determination. Having the infrastructure in the 
> > > kernel is an important part of this, but there'll be some distance 
> > > to go after that.
> > 
> > What will the 'user space policy' bit do what the kernel cannot?
> 
> How does the kernel know whether the user cares about SATA hotplug 
> or not?

The typical user probably doesnt know what 'SATA' means, and 
probably has very vague concepts about 'hotplug' as well.

The kernel default should be: 'yes, if the kernel feature is enabled 
and if the hardware can support it' (it's not on a blacklist of some 
sort, etc., etc.).

> > If you mean the user has to configure something manually - that 
> > wont really happen in practice. We are happy if they know where 
> > to put those USB sticks in ;-)
> 
> It'll be up to the distributions to provide sane defaults and let 
> them be reconfigured as necessary, depending on the information we 
> have from the user and maybe platform-specific knowledge. But this 
> is a difficult problem - we need to be smart about all the 
> potential sources of information in order to pick an appropriate 
> policy, and the kernel's not the right layer to do some of this 
> information collection.

What sources of information exactly? Again, the user wont enter 
anything, in 95% of the cases - in the remaining 3% of cases what is 
entered is wrong and only in another 2% of cases is it correct ;-)

Sane kernel defaults are important and the kernel sure knows what 
kind of hardware it runs on. This 'let the user decide policy' for 
something as fundamental (and also as arcane) as power saving mode 
is really a disease that has caused a lot of unnecessary pain in 
Linux in the past 15 years.

Sure, there might be tradeoffs when a piece of hardware cannot be 
turned off sanely: obviously the monitor might not know it 
(currently) whether someone is watching it, and 
wake-on-packet-for-me is not commonly implemented in wireless and 
wired networking cards so turning off an active networking card 
might not be possible without the user asking allowing that 
imperfect mode of power saving.

But there are plenty of cases where turning off hardware is fine, 
and the broken special cases will go away as technology advances, 
and we should not design based on broken concepts.

( Providing a way to _override_ those defaults is of course natural,
  via /sysfs, should the user express an interest in tweaking it, or
  should the kernel get it so wrong that a distro wants to work it
  around. But your argument seems to be "push configuration and
  handling into user-space" which is really backwards. )

	Ingo
