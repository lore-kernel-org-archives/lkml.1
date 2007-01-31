Return-Path: <linux-kernel-owner+w=401wt.eu-S933293AbXAaOVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293AbXAaOVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 09:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933291AbXAaOVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 09:21:51 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:35220 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293AbXAaOVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 09:21:51 -0500
X-Originating-Ip: 74.109.98.130
Date: Wed, 31 Jan 2007 09:20:35 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       dhowells@redhat.com, rth@twiddle.net
Subject: Re: [PATCH] Centralize the selection for debugging semaphores.
In-Reply-To: <6bffcb0e0701310600s192f462aw18c96dce5630fe25@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0701310913140.5526@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0701310825500.4627@CPE00045a9c397f-CM001225dbafb6>
  <6bffcb0e0701310544w474810cfh83fbfa539e1c0573@mail.gmail.com> 
 <Pine.LNX.4.64.0701310852460.4816@CPE00045a9c397f-CM001225dbafb6>
 <6bffcb0e0701310600s192f462aw18c96dce5630fe25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007, Michal Piotrowski wrote:

> On 31/01/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> > On Wed, 31 Jan 2007, Michal Piotrowski wrote:
> >
> > > On 31/01/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> > > >
> > > >   Centralize the kernel config option for debugging semaphores and
> > > > modify the macro for frv to use that config option instead.
> > > >
> > > > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> > > [..]
> > > > +config DEBUG_SEMAPHORE
> > > > +       bool "Semaphore debugging"
> > > > +       depends on DEBUG_KERNEL
> > > > +       default n
> > > > +       help
> > > > +         If you say Y here then semaphore processing will issue lots of
> > > > +         verbose debugging messages.  If you suspect a semaphore
> > problem or
> > > > a
> > > > +         kernel hacker asks for this option then say Y.  Otherwise say
> > N.
> > > > +
> > > > +         At the moment, this is implemented only by alpha and frv.
> > >
> > > IMHO this option should stay in arch/{alpha,frv}/Kconfig.debug
> >
> > any particular reason?
>
> Only this
> "At the moment, this is implemented only by alpha and frv."
>
> It depends on architecture.

  yes, i realize that, but surely there's a cleaner way to implement
something that's supported by only *some* of the architectures rather
than duplicating the code for every one of those architectures.

  one possibility is to have the global config option look like this:

config DEBUG_SEMAPHORE
	bool "Semaphore debugging"
	depends on DEBUG_KERNEL && HAVE_SEMAPHORE_DEBUGGING
				   ^^^^^^^^^^^^^^^^^^^^^^^^
        default n
	...

  at that point, any architecture that implements semaphore debugging
and wants to advertise that simply needs to add this at the top of its
Kconfig.debug file:

config HAVE_SEMAPHORE_DEBUGGING
        def_bool y

  that was just off the top of my head, but it seems to work.  more
generally, though, surely this sort of thing has come up before --
wanting to advertise an identical user-configurable option only for
certain architectures.  how is that done *now* without rampant code
duplication?  or is it?

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel
Pedantry Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
