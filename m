Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbZLFCfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbZLFCfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 21:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbZLFCfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 21:35:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36565 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbZLFCfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 21:35:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Date: Sun, 6 Dec 2009 03:36:23 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <200912052216.19540.rjw@sisk.pl> <200912060254.10081.rjw@sisk.pl> <alpine.LFD.2.00.0912051758190.3560@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912051758190.3560@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912060336.24029.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 December 2009, Linus Torvalds wrote:
> 
> On Sun, 6 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > While the current settings are probably unsafe (like enabling PCI devices
> > to be suspended asynchronously by default if there are not any direct
> > dependences between them), there are provisions to make eveything safe, if
> > we have enough information (which also is needed to put the required logic into
> > the drivers).
> 
> I disagree.
> 
> Think of a situation that we already handle pretty poorly: USB mass 
> storage devices over a suspend/resume.
> 
> > The device tree represents a good deal of the dependences
> > between devices and the other dependences may be represented as PM links
> > enforcing specific ordering of the PM callbacks.
> 
> The device tree means nothing at all, because it may need to be entirely 
> rebuilt at resume time. 

With that assumption we have no choice but to leave the async stuff to the
drivers, which generally I'm fine with, although I really don't expect to see
it done.

> Optimally, what we _should_ be doing (and aren't) for suspend/resume of 
> USB is to just tear down the whole topology and rebuild it and re-connect 
> the things like mass storage devices. IOW, there would be no device tree 
> to describe the topology, because we're finding it anew. And it's one of 
> the things we _would_ want to do asynchronously with other things.

I think you should tell that to the USB people, because they don't seem to
think this way.

[Side note, I do think that at least some information in the device tree will
remain valid over suspend/resume, but this is a different matter.]

> We don't want to build up some irrelevant PM links and callbacks. We don't 
> want to have some completely made-up new infrastructure for something that 
> we _already_ want to handle totally differently for init time.
> 
> IOW, I argue very strongly against making up something PM-specific, when 
> there really doesn't seem to be much of an advantage. We're much better 
> off trying to share the init code than making up something new.
> 
> > I'd say if there's a worry that the same register may be accessed concurrently
> > from two different code paths, there should be some locking in place.
> 
> Yeah. And I wish ACPI didn't exist at all. We don't know.
> 
> And we want to _limit_ our exposure to these things.

Don't worry, I'm not going to touch async suspend/resume again, unless
somebody makes me do it.

BTW, you seem to have some quite strong opinions about power management that
you only share with people when somebody sends you patches you don't like.  I
guess it will be much more productive if we know your thoughts about it in
advance, so I hope you won't mind being sent CCs of core PM patches posted to
linux-pm for discussions.

Thanks,
Rafael
