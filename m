Return-Path: <linux-kernel-owner+w=401wt.eu-S966650AbXEKUEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966650AbXEKUEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758933AbXEKUEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:04:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60582 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310AbXEKUEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:04:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] swsusp: Use platform mode by default
Date: Fri, 11 May 2007 22:08:52 +0200
User-Agent: KMail/1.9.5
Cc: Coywolf Qi Hunt <coywolf@gmail.com>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Starikovskiy <alexey_y_starikovskiy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       linux-acpi@vger.kernel.org, Stefan Seyfried <seife@suse.de>
References: <200611011323.14830.rjw@sisk.pl> <200705111121.51704.rjw@sisk.pl> <alpine.LFD.0.98.0705110912290.3986@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705110912290.3986@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705112208.53971.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 11 May 2007 18:30, Linus Torvalds wrote:
> 
> On Fri, 11 May 2007, Rafael J. Wysocki wrote:
> > 
> > We're working on fixing the breakage, but currently it's difficult, because
> > none of my testboxes has problems with the 'platform' hibernation and I
> > cannot reproduce the reported issues.
> 
> The rule for anything ACPI-related has been: no regressions.
> 
> It doesn't matter if something fixes 10 boxes, if it breaks a single one, 
> it's going to get reverted.

[Well, I think I should stop explaining decisions that weren't mine.  Yet, I
feel responsible for patches that I sign-off.]

Just to clarify, the change in question isn't new.  It was introduced by the
commit 9185cfa92507d07ac787bc73d06c42222eec7239 before 2.6.20, at Seife's
request and with Pavel's acceptance.

> We had much too much of the "two steps forward, one step back" dance with 
> ACPI a few years ago, which is the reason that rule got installed (and 
> which is why it's ACPI-only: in some other subsystems we accept the fact 
> that sometimes we don't know how to fix some hardware issue, but the new 
> situation is at least better than the old one).
> 
> I agree that it can be aggravating to know that you can fix a problem for 
> some people, but then being limited by the fact that it breaks for others. 
> But beign able to *rely* on something that used to work is just too 
> important, and with ACPI, you can never make a good judgement of which way 
> works better (since it really just depends on some random firmware issues 
> that we have zero visibility into).
> 
> Also, quite often, it may *seem* like something fixes more boxes than it 
> breaks, but it's because people report *breakage* only, and then a few 
> months later it turns out that it's exactly the other way around: now it's 
> a hundred people who report breakage with the *new* code, and the reason 
> people thought it fixed more than it broke was that the people for whom 
> the old code worked fine obviously never reported it!
> 
> So this is why "a single regression is considered more important than ten 
> fixes" - because a single regressionr report tends to actually be just the 
> first indication of a lot of people who simply haven't tested the new code 
> yet! People for whom the old code is broken are more likely to test new 
> things.
> 
> So I'd just suggest changing the default back to PM_DISK_SHUTDOWN (but 
> leave the "pm_ops->enter" testing in place - ie not reverting the other 
> commits in the series).

The series actually preserves the 2.6.20/21 behavior.  By defaulting back to
PM_DISK_SHUTDOWN, we'll cause some users for whom 2.6.20 and 2.6.21 work to
report this change as a regression, so please let me avoid making this decision
(I'm not the maintainer of the hibernation code after all).

The problem is that we don't know about regressions until somebody reports them
and if that happens after two affected kernel releases, what should we do?

Rafael
