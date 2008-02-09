Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbYBIPNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbYBIPNg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbYBIPN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:13:26 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:33369 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYBIPNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:13:24 -0500
Date: Sat, 9 Feb 2008 16:13:22 +0100
From: Christer Weinigel <christer@weinigel.se>
To: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
Cc: David Newall <davidn@davidnewall.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       Diego Zuccato <diego@otello.alma.unibo.it>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080209161322.6ccd9d4d@weinigel.se>
In-Reply-To: <20080207184939.17030887@dilbert.local>
References: <20080125180232.GA4613@kroah.com>
	<20080202123710.42df1aa0@weinigel.se>
	<20080202191930.GA19826@kroah.com>
	<47A5D895.20300@davidnewall.com>
	<47A6E742.80408@otello.alma.unibo.it>
	<47A764ED.8030605@weinigel.se>
	<1202161091.15090.84.camel@violet>
	<20080206213449.6614efea@weinigel.se>
	<20080206215442.63c94cf3@dilbert.local>
	<47AB056E.70802@davidnewall.com>
	<20080207150612.21ba60df@dilbert.local>
	<47AB163C.5070107@davidnewall.com>
	<20080207171322.40eb7c95@dilbert.local>
	<47AB36D2.5050602@davidnewall.com>
	<20080207184939.17030887@dilbert.local>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 18:49:39 +0100
Hans-Jürgen Koch <hjk@linutronix.de> wrote:

> > It requires software that is *distributed* as part of a GPL
> > work to itself be GPL.  At time of distribution, a kernel module is
> > neither using nor linked to the kernel.
> 
> Oh, come on! You cannot turn a derived work into an original work just
> by distributing them seperately.

No, but the other way doesn't work either.  

Lets say that I write a piece of code, a B-tree algorithm.  If I take
that piece of code and put it in the Linux kernel and distribute it as
a statically linked binary kernel, then quite obviously the whole is a
derived work of the original Linux kernel and my b-tree code.  If I
refuse to give the source code to my b-tree code [1] I have obviously
violated the GPL.  That is very clear and I don't think anyone disputes
that.

What is more disputed is if my b-tree code is a derivative work of the
kernel or not.  In my opinion it is not, that b-tree code is my
original work and I can ship it as a part of a proprietary product if I
want to.  If I distribute it as a .o file and somebody links it into
the kernel, that is the end users decision, and the GPL explicitly says
"Activities other than copying, distribution and modification are not
covered by this License; they are outside its scope.  The act of
running the Program is not restricted [...]".  

But lets say that the b-tree code uses Linux-only primitives such as
kmalloc or spinlocks, and that I wrote the code specifically for the
Linux kernel, does that make it into a derivative work?  kmalloc is
only a function call, so I'd say that is too trivial to be
copyrightable, APIs or just directories mapping names to numbers are
not copyrightable.  The spinlocks are a bit more troublesome since they
are implemented as macros or inline functions so they do pull in some
code from the header files.  On the other hand, since they in a way form
an API, and are the only way of interoperating with the kernel, they
might not be copyrightable either.  Then there's the question of fair
use which might also make it possible to legally use those functions
anyway, even if they are copyrightable.  

What if I do a trivial replace of the kmalloc calls with malloc and the
spinlock calls with pthread locks instead, has my code been forever
tainted by being written for Linux so that I can't do that anymore?
What if I go the other way and write my code using the posix functions
to begin with and do the equally trivial replace of malloc with
kmalloc?  

So static linking vs dynamic linking really isn't the question.  But 
linking something statically and distributing the resulting binary
without providing source, that is a very blatant violation of the GPL,
so that is fairly easy to bring to court.   As far as I know, the
question if using the kernel header files creates a derivative work or
not has not been decided in court though, and until it has it is a bit
of a gray zone.  And even if it is decided in a court in Germany for
example, that ruling might not apply in the states or in Australia.
The Berne convention is supposed to harmonise the copyright laws all
over the world, but there are still differences between countries.

Every time Harald Welte sues a company and that company settles by
paying up, it strengthens the position that the GPL is valid, but since
those settlements are made outside of court, no outsider can tell why
they settled.  Was it because the company had blatantly violated the
GPL by refusing to give away source (a lot of WLAN routers made by
Chinese companies seemed to fall into that category), was it because
they were using GPLed source in their drivers (a lot of binary modem
drivers was modified versions of the serial driver straight from the
Linux kernel, an obvious violation), or was it because the court hinted 
that they would actually consider an original device driver written for
Linux as a derivative work?  Or was it just because the companies felt
that the fight wasn't worth the time and money, and it's easier to
settle than to spend a lot of money on a fight, especially since
there's always a small risk that you can get hurt in a fight?

Patent trolls use the same tactics, they sue small companies and offer
them settlements which are less risky than fighting it out in court, so
most small companies settle.  The trolls then use those settlements as
"proof" that their claims are valid, and with the settlement money they
take on bigger victims.  Now, I do consider Welte's suits a wee bit [2]
more valid than patent trolls, and I'm happy he has the energy to do
that.  But using his victories, which usually seem to be regarding very
blatant GPL violations, as some kind of proof in the
derivative-work-or-not debate, isn't really valid.

   /Christer (rambling again)

[1] Or if I give the source code to the recipient and say "here's the
source code, but you can't give it to someone else".

[2] That is an understatement, ok?
