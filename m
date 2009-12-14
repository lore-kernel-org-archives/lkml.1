Return-Path: <linux-kernel-owner+w=401wt.eu-S932941AbZLNWLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbZLNWLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbZLNWLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:11:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48951 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932676AbZLNWLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:11:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Mon, 14 Dec 2009 23:11:31 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912122334.08367.rjw@sisk.pl> <alpine.LFD.2.00.0912141015240.26135@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912141015240.26135@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912142311.31658.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 December 2009, Linus Torvalds wrote:
> 
> On Sat, 12 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > One solution that we have discussed on linux-pm is to start a bunch of async
> > threads searching for async devices that can be suspended and suspending
> > them (assuming suspend is considered) out of order with respect to dpm_list.
> 
> Ok, guys, stop the crazy.
> 
> That's another of those "ok, that's just ttoally stupid and clearly too 
> complex" ideas that I would never pull.
> 
> I should seriously suggest that people just stop discussing architectural 
> details on the pm list if they all end up being this level of crazy.
> 
> The sane thing to do is to just totally ignore the async layer on PCI 
> bridges and other things that only have a late-suspend/early-resume thing. 
> No need for the above kind of obviously idiotic crap.
> 
> However, my point was really that we wouldn't even have _needed_ that kind 
> of special case if we had just decided to let the subsystems do it. But 
> whatever. At worst, the PCI layer can even just mark such devices with 
> just late/early suspend/resume as being asynchronous, even though that 
> ends up resulting in some totally pointless async work that doesn't do 
> anything.
> 
> But please guys - reign in the crazy ideas on the pm list. It's not like 
> our suspend/resume has gotten so stable as to be boring, and we want it to 
> become unreliable again.

Indeed.

OK, what about a two-pass approach in which the first pass only inits the
completions and starts async threads for leaf "async" devices?  I think leaf
devices are most likely to take much time to suspend, so this will give us
a chance to save quite some time.

A more aggressive version of this might start the async threads for all async
devices in the first pass and then only handle the sychronous ones in the
second pass - as long as there are only a few async devices that should be
quite efficient.

Rafael
