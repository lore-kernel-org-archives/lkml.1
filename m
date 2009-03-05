Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZCETKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZCETKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZCETKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:10:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51803 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbZCETKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:10:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore standard config registers of all devices early)
Date: Thu, 5 Mar 2009 20:09:52 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <1236209104.6696.73.camel@pasglop> <20090305081908.GA30418@elf.ucw.cz>
In-Reply-To: <20090305081908.GA30418@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903052009.54241.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 March 2009, Pavel Machek wrote:
> On Thu 2009-03-05 10:25:04, Benjamin Herrenschmidt wrote:
> > 
> > > As long as we claim to support cpu hotplug, suspending the cpus early
> > > should work. User might have unplugged the cpu manually...
> > > 
> > > If something is broken in acpi, we may need to disable  cpu*/onlone on
> > >  affected systems.
> > 
> > You seem to miss some context here... it seems that ACPI mandates that
> > CPUs are suspended after devices and you know that we can't just start
> > blacklisting half of the machines out there just because we happen not
> > to do the same as what Windows does...
> 
> I did not see that ACPI mandate... where is it?

15.1.6 in ACPI 3.0b (for example).

This is more complicated, though.  Turning the CPUs on/off involves things
that need to be ordered with respect to _PTS, _WAK in a specific way (ie. just
like we do it right now, which is _PTS before disable_nonboot_cpus() and
enable_nonboot_cpus() before _WAK).  Otherwise at least some machines will
break (verified experimentally some time ago).

Thanks,
Rafael
