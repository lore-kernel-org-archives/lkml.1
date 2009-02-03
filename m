Return-Path: <linux-kernel-owner+w=401wt.eu-S1751983AbZBCWpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbZBCWpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 17:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZBCWpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 17:45:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41693 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbZBCWo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 17:44:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore standard config registers of all devices early)
Date: Tue, 3 Feb 2009 23:44:21 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902032253.42709.rjw@sisk.pl> <1233700390.16867.97.camel@pasglop>
In-Reply-To: <1233700390.16867.97.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902032344.22348.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009, Benjamin Herrenschmidt wrote:
> On Tue, 2009-02-03 at 22:53 +0100, Rafael J. Wysocki wrote:
> 
> > That would change the ordering of ACPI method calls, which also is important
> > and prone to breaking, as I wrote in the original message.
> 
> Ok, I'm not -that- familiar with ACPI, but I don't see where this
> ordering change you seem to fear is ... Ie, what gets re-ordered vs.
> what ? 

(Newer) ACPI says that devices should be put into low power states (presumably
with the help of appropriate ACPI AML routines) before the _PTS method is
called.  In turn, we're supposed to disable nonboot CPUs after calling _PTS.
There is analogous requirement for the _WAK method during resume.

Currently, the suspend code ordering follows these rules, but if we move
the putting of devices into low power states into the suspend_late part, they
will have to be done after _PTS and that is likely to break things (we've
already had this problem once and I have really bad memories related to it).

Thanks,
Rafael
