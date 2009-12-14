Return-Path: <linux-kernel-owner+w=401wt.eu-S932393AbZLNSW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbZLNSW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 13:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932357AbZLNSWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 13:22:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932356AbZLNSWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 13:22:24 -0500
Date: Mon, 14 Dec 2009 10:21:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912122334.08367.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912141015240.26135@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912121848.33062.rjw@sisk.pl> <alpine.LFD.2.00.0912121049390.3526@localhost.localdomain> <200912122334.08367.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Dec 2009, Rafael J. Wysocki wrote:
> 
> One solution that we have discussed on linux-pm is to start a bunch of async
> threads searching for async devices that can be suspended and suspending
> them (assuming suspend is considered) out of order with respect to dpm_list.

Ok, guys, stop the crazy.

That's another of those "ok, that's just ttoally stupid and clearly too 
complex" ideas that I would never pull.

I should seriously suggest that people just stop discussing architectural 
details on the pm list if they all end up being this level of crazy.

The sane thing to do is to just totally ignore the async layer on PCI 
bridges and other things that only have a late-suspend/early-resume thing. 
No need for the above kind of obviously idiotic crap.

However, my point was really that we wouldn't even have _needed_ that kind 
of special case if we had just decided to let the subsystems do it. But 
whatever. At worst, the PCI layer can even just mark such devices with 
just late/early suspend/resume as being asynchronous, even though that 
ends up resulting in some totally pointless async work that doesn't do 
anything.

But please guys - reign in the crazy ideas on the pm list. It's not like 
our suspend/resume has gotten so stable as to be boring, and we want it to 
become unreliable again.

			Linus
