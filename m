Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbXI1VZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbXI1VZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbXI1VZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:25:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48373 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbXI1VZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:25:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: [patch 0/2] suspend/resume regression fixes
Date: Fri, 28 Sep 2007 23:40:22 +0200
User-Agent: KMail/1.9.5
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <20070922220347.586903979@linutronix.de> <1191011610.18681.94.camel@chaos> <46FD6F83.8070801@rtr.ca>
In-Reply-To: <46FD6F83.8070801@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709282340.23730.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 28 September 2007 23:17, Mark Lord wrote:
> Thomas Gleixner wrote:
> > On Fri, 2007-09-28 at 16:27 -0400, Mark Lord wrote:
> ..
> >> On a closely related note:  I just now submitted a patch to fix SMP-poweroff,
> >> by having it do disable_nonboot_cpus before doing poweroff.
> >>
> >> Which has led me to thinking..
> >> ..are similar precautions perhaps necessary for *all* ACPI BIOS calls?
> >>
> >> Because one never knows what the other CPUs are doing at the same time,
> >> and what the side effects may be on the ACPI BIOS functions.
> >>
> >> And also, I wonder if at a minimum we should be guaranteeing ACPI BIOS calls
> >> only ever happen from CPU#0 (or the "boot" CPU)?   Or do we do that already?
> > 
> > The ACPI calls are serialized in the kernel, AFAICT. But the fragile
> > situations (suspend, resume, shutdown, reboot) are probably those, where
> > some BIOS implementation expect that certain things are not called or
> > not active.
> 
> Mmm.. *do* we actually do this for reboot?  I don't see it there.
> And how about for kexec?
> 
> I'm probably just missing seeing it.  Right?

Nope.

Till now, only hibernation and suspend disabled the nonboot CPUs before
invoking the platform firmware.

Greetings,
Rafael
