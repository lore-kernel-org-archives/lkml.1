Return-Path: <linux-kernel-owner+w=401wt.eu-S1759855AbZBCAan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855AbZBCAan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbZBCAad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:30:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36089 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363AbZBCAac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:30:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: PCI PM: Restore standard config registers of all devices early
Date: Tue, 3 Feb 2009 01:29:51 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902030000.18049.rjw@sisk.pl> <1233620590.18767.138.camel@pasglop>
In-Reply-To: <1233620590.18767.138.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902030129.52445.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009, Benjamin Herrenschmidt wrote:
> 
> > But we can't tell no one is holding the mutex in question, AFAICS.
> > 
> > I'm afraid we'd really need a special "no mutexes, no GFP_KERNEL allocations"
> > code path for that.
> 
> No, the mutex shouldn't be held already, if it is, you're probably
> already in deep trouble. IE, you probably want to enfore that anyway,
> ie, it wouldn't be very sane to suspend the machine while ACPI was
> already in the -middle- of interpreting something anyway.
> 
> IE, you should have something to ensure, before you turn interrupts off,
> that nobody else is inside the AML interpreter. You already know there
> are no other CPUs, so it's just a matter of making sure no other process
> has scheduled while holding that mutex.
> 
> The easy way to do that is to do something like taking the mutex
> yourself and then setting a flag so that the intepreter stops trying to
> take it or release it itself, maybe just using the global system state.
> 
> Then release the mutex on resume.

Yes, that should work.

> All of these are issues that exist today. IE. Regardless of that
> powermac problem, which is unrelated (see other posts), I think these
> things need to be sorted cleanly or suspend will not be as rock solid as
> it could/should be. IE. It's several order of magnitude better than it
> was, I agree, but I believe we have here a few reasonably simple things
> we can/should do to make it more robust.

Agreed.

Thanks,
Rafael
