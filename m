Return-Path: <linux-kernel-owner+w=401wt.eu-S1762594AbXEZRJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762594AbXEZRJg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 13:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbXEZRJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 13:09:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:37802 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752783AbXEZRJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 13:09:28 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX1/iMjQQ3Vji9ocQYleRTgYEylOWgCHG7+5v7jb6Yp
	n+HlbzCK/czRL2
From: Uwe Bugla <uwe.bugla@gmx.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 19:04:04 +0200
User-Agent: KMail/1.9.5
References: <20070524195616.234280@gmx.net> <200705261826.06796.uwe.bugla@gmx.de> <200705261840.45896.mb@bu3sch.de>
In-Reply-To: <200705261840.45896.mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705261904.04496.uwe.bugla@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 26. Mai 2007 18:40 schrieben Sie:
> On Saturday 26 May 2007 18:26:06 Uwe Bugla wrote:
> > > I think we don't have IRQ assignment problems. Uwe simply disabled
> > > b44-PCI support in his first bugreport (I guess).
> >
> > Yes!
> >
> > > So there was
> > > no b44-PCI driver loaded.
> >
> > Well, not exactly: b44 plus ssb were in fact produced, but did not
> > function, at least in that case, due to the misleading / superficial
> > information in the Kconfig menu......
> >
> > > Later on he said that it does magically work now...
> >
> > NO!
> >
> > Later on I said I did chose that b44-PCI driver, got the right
> > dependencies, and there was no interrupt problem at all. So the driver
> > got loaded as expected but simply did not work at all......
>
> One small sidenote:
> If you did _not_ play around with the b44/ssb kconfig options at all,
> it would have selected the right options _automatically_ for you.
> That means:
>
> cp ../old_kernel_without_ssb/.config .
> make oldconfig
> make
> be done.
>
> You intentionaly disabled PCI device support for b44 and you
> still wonder why it doesn't work on your PCI device?
> I'm not sure how to make the helptext any clearer on the b44-PCI
> option. 

A. Up to 2.6.21 there was only a b44 PCI driver. So you get used to it working 
with the same machine for years and compiling kernels for it.
B. Now there are obviously some changes due to the "bus-glue". OK so far!

But: The help text in both cases is exactly the same. And exactly that is the 
misleading point!
The best way to put up a very clear distinction is to use some examples to 
explain the different cases. Now if you can offer me enough info on that I 
can try to do write a patch for that.
So we got the Broadcom PCI b44 NIC driver (as card, as onboard device)
and we got additionally what please as a new extension??
Just two or three examples would do it!
Above that perhaps the dependencies could be a bit more precise:

Wouldn't you get confused if you deselcted the PCI or Ethernet option, but 
still retaining the same b44 driver selected as module with the identical 
help text?

Is that so hard to understand?

> We have _lots_ of other drivers in the tree that work 
> EXACTLY the same way, regarding to kconfig. There are _lots_
> of drivers where there are seperate options for a "bus-glue".
> b44-ssb is no different. And additionally it automatically
> selects the right options for 99.9% of the users (you included).

Yes, sure! But the help text is very unlucky and humble, and it is not clear 
enough in the sense of being distinctive enough, just clear and 
comprehensive.

>
> So I'm not sure why you keep bashing the kconfig implementation
> here. It's common practice to have seperate config options for
> bus-glues and it _automatically_ selects the right options for
> you.

Yes! But you need to EXPLAIN that "bus-glue" in the Kconfig help text in some 
two or three sentences. That shouldn't be that hard, should it?

And that is exactly the basic function of a Kconfig help text: To explain 
kernel compilation choices to users!

It is very very easy to simply ignore that fact and then, afterwards, call all 
people dumb who are not "omniscient" at all to see the differences through.
Where should they know from if they are not identical with your personality?

Cheers

Uwe
