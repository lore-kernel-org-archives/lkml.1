Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbYARJEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbYARJEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbYARJEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:04:09 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:42576 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbYARJEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:04:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wbrTqnbwn8QI79XBRNG8cafB06Jwag/J1E+k4QYJlFXwAjchCxZrUlyioOrbRKviJ/7nicgaR2I43FKa7VyEhj68R5WI4tJVDUJeIFHmxi39lDaACK9aBLLoAFxu0/JV+64JUSaIwafPGKe5TVGgeqw6f/zLTzwMEBRM1OuX4gQ=
Subject: Re: echo mem > /sys/power/state
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Zan Lynx <zlynx@acm.org>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080118004725.dcd132ee.akpm@linux-foundation.org>
References: <20080116222445.6f7ff66e.akpm@linux-foundation.org>
	 <1200591411.34145.4.camel@localhost>
	 <20080117111355.29554f38.akpm@linux-foundation.org>
	 <200801172238.17176.rjw@sisk.pl> <20080118083610.GA19792@elte.hu>
	 <20080118004725.dcd132ee.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 01:04:04 -0800
Message-Id: <1200647044.5724.123.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-18 at 00:47 -0800, Andrew Morton wrote:
> On Fri, 18 Jan 2008 09:36:10 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > > Probably it would be more efficient to have the people who wrote the 
> > > > code also test it.
> > > 
> > > Well, that would certainly help.
> > > 
> > > I do test all of my patches and generally all of the patches I sign 
> > > off, but surely that's not enough.
> > 
> > please add a .config option dependent on CONFIG_DEBUG_KERNEL=y [and 
> > default-disabled] that auto-tests suspend/resume functionality 60 
> > seconds after hitting user-space (the suspend/resume cycle kept small 
> > via a small RTC timeout) and s2ram correctness will be tested _a lot_ 
> > more.
> > 
> > (it doesnt matter if graphics does not resume fine - at least for my 
> > tests)
> > 
> > kprobes had similar problems and it now has a few simple smoke-tests - 
> > which i just saw trigger on a patch that i did not notice would break 
> > kprobes. I think this should be done for all functionality that is not 
> > regularly triggered by a normal distro bootup (and which is easy to 
> > overlook in testing).
> > 
> 
> Seeing as we're so lame about being able to distribute userspace stuff:
> create a shell script in /proc/rc.kernel and start teaching initscripts to
> run it.  Then we can modify it at will.
> 
> I hate me.

With all the discussion lately about boot-time smoketests and self-tests
maybe this kind of stuff would be a good first candidate for useful
new early-userspace functionality.  Then the kernel build could be
taught about building an initramfs that runs a bunch of tests
and leaves the user in a shell letting them know if it passed or not.

This would be a great way for increasing the number of testers, just
ask them to build with that option and a _known_ testsuite could
be reported as working or not.

Or maybe I'm out to lunch....

Harvey

