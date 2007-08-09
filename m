Return-Path: <linux-kernel-owner+w=401wt.eu-S938908AbXHIHlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938908AbXHIHlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 03:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932787AbXHIHlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 03:41:14 -0400
Received: from www.osadl.org ([213.239.205.134]:38338 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932713AbXHIHlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 03:41:13 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH 2/3] UIO: Documentation
Date: Thu, 9 Aug 2007 09:41:09 +0200
User-Agent: KMail/1.9.5
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <20070718232332.GA4620@kroah.com> <11848012122374-git-send-email-gregkh@suse.de> <9a8748490708081436g23c8f01cga585d6612b380f16@mail.gmail.com>
In-Reply-To: <9a8748490708081436g23c8f01cga585d6612b380f16@mail.gmail.com>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708090941.09484.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 08 August 2007 23:36 schrieb Jesper Juhl:
> On 19/07/2007, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> > From: Hans J. Koch <hjk@linutronix.de>
> >
> > Documentation for the UIO interface
> >
> ...
> > +<para>If you use UIO for your card's driver, here's what you get:</para>
> > +
> ...
> > +<listitem>
> > +       <para>if you need to keep some parts of your driver closed source,
> > +       you can do so without violating the GPL license on the kernel.</para>
> > +</listitem>
> > +</itemizedlist>
> > +
> ...
> 
> Do we really want this?

Yes. Please remember that UIO is for industrial I/O cards, not mainstream
PC hardware. You'll never see an UIO driver for an USB Scanner or a TV card.
Just try to write one. You will see that an UIO kernel driver for a device 
that has to interact with lots of kernel subsystems will become almost as
big as a normal kernel driver. Not much left for user space.

Typical industrial IO cards are simple PCI cards with loads of 
functions that don't fit in any kernel subsystem. A pure kernel driver
is usually _big_ and ugly and introduces 50 new ioctls and will never
make it into mainline.

> 
> In my oppinion we run the risk here of encouraging behaviour akin to
> what NVidia is doing - release a small kernel "glue" module and then
> keep the driver proper in a binary blob (in userspace, but still a
> binary blob).

If a company wants to do that, they'll do it, with or without UIO.

> If the company goes out of business and take their driver source with
> them then users are left with a useless, un-debugable, un-maintainable
> binary blob.
> Don't we instead want to encourage/pressure people to release specs
> and/or source code for their hardware/drivers so open, modifiable
> drivers can be written?

No. Please note that there _are_ reasons to keep code closed. I agree
with you when it comes to mass market hardware like graphics cards.
But in embedded systems with custom hardware for military or other
critical applications, you can't force a manufacturer to show you
his concepts. Usually, he's not allowed to.

UIO offers a legal way for these people to implement their driver.
Without it, they'll violate the GPL or don't use Linux at all.

> 
> This opens the door for people to start writing closed drivers. 

No. UIO doesn't change anything. You were always free to choose
your license for userspace stuff.

What we want to achieve is that IO cards, for which you get a
driver with 5000 lines of unreadable code for 2.6.12 from the
manufacturer at the moment, can get a sensible driver with
mainline support. That's all. We will see if that encourages
manufacturers to make drivers closed source.

Thanks,
Hans
