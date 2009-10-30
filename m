Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbZJ3Uk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbZJ3Uk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 16:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbZJ3Uk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 16:40:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757406AbZJ3Uk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 16:40:26 -0400
Date: Fri, 30 Oct 2009 13:40:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from
 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
In-Reply-To: <200910302132.44759.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.01.0910301335570.31845@localhost.localdomain>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200910301948.24473.rjw@sisk.pl> <alpine.LFD.2.01.0910301228430.31845@localhost.localdomain> <200910302132.44759.rjw@sisk.pl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Oct 2009, Rafael J. Wysocki wrote:

> On Friday 30 October 2009, Linus Torvalds wrote:

> > The PCMCIA code is better than it used to be a long time ago, but some of 
> > it is still pretty crazy. 
> > 
> > I get the feeling that we should just revert that commit 0c570cdeb,
> 
> Well, there's nothing wrong with doing the PCI stuff and restoring the state at
> the _noirq stage IMO, so instead of reverting it altogether, I'd add
> yenta_dev_suspend|resume() that would just call
> pcmcia_socket_dev_suspend|resume() during "regular" suspend|resume.

Oh, that sounds fine too. I didn't mean that we had to do an outright 
revert, since we'd still need to do something else to fix the original 
issue.

> > and instead always do PCMCIA suspend as a "eject" event. That way we have no 
> > driver behind it to resume at resume time - and we'll see any plugged-in 
> > device as just a new insertion. 
> 
> In fact I thought about that.
> 
> It looks like I need to find a CardBus adapter somewhere and clean that thing up.
> 
> That said, I'd really like to know what's going on in there. :-)

I have to admit that my last two laptops haven't even _had_ a PCMCIA slot, 
so I'm unlikely to be able to help much. But I could dig out an old one, 
and try to find the one wireless card I know I have in some corner.

And partly exactly _because_ even Cardbus is starting to be "legacy", I'd 
personally prefer to try to simplify the model to the point where we don't 
have to think about all the subtle interactions. Just making suspend act 
as an eject would mean that we'd never have to worry about how the CardBus 
bridge interacts with the PCI layer at suspend/resume time.

		Linus
