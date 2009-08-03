Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbZHCSpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbZHCSpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbZHCSpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:45:06 -0400
Received: from www84.your-server.de ([213.133.104.84]:52371 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbZHCSpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:45:05 -0400
Subject: Re: [RFC 0/2] new kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, open-iscsi@googlegroups.com,
       Mike Christie <michaelc@cs.wisc.edu>
In-Reply-To: <200908032023.15355.arnd@arndb.de>
References: <1249306755.8358.8.camel@wall-e>
	 <200908031642.15136.arnd@arndb.de> <1249312458.23559.25.camel@wall-e>
	 <200908032023.15355.arnd@arndb.de>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 20:45:00 +0200
Message-Id: <1249325100.3800.11.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 03.08.2009, 20:23 +0200 schrieb Arnd Bergmann:
> On Monday 03 August 2009, Stefani Seibold wrote:
> > Am Montag, den 03.08.2009, 16:42 +0200 schrieb Arnd Bergmann:
> > > My guess is that more importantly
> > > 
> > > - few people so far needed the functionality.
> > 
> > This is not true, that is only your view. Don't speak for other people.
> > A lot of device driver developer has its own implement of a fifo. I have
> > written a lot of device drivers for embedded system and i always missed
> > a clean designed and implemented fifo API subsystem.
> 
> As I said, I was only guessing from the only evidence we both had, which
> is the current use in the kernel. Your extrapolation was that it did
> not get used much because of the quality of the existing API, my
> extrapolation was that there is no need for it (at least I was
> never looking for it in any of my drivers).
> 

Maybe..... 

> > > This sounds all nice, and your code looks clean and usable, but really,
> > > what's your point?
> > > 
> > > If you have a new driver that will use all the new features, please
> > > just tell us, that would make your point much clearer. Also, if
> > > you can quantify an advantage (xxxx bytes code size reduce, yy%
> > > performance improvement on Y benchmark) that would be really
> > > helpful.
> > > 
> > 
> > Yes, i have some drivers where i use a former version of the kfifo API.
> > But the real advantage is not benchmarking.
> >
> > First if we have a useable kfifo API i think other developer will use
> > it. And this will save memory.
> 
> Being able to simplify code is obviously good, but the normal
> approach of doing it is to make it obvious in what ways. Exchanging
> a whole API at once makes it unobvious what changes you do for which
> purpose. 
> 

It is not a complete change of the API. There are two main things which
are different:

The kfifo_get and kfifo_put functions are extended by two new
parameters: flag and total. Setting both to there will result in the old
behavior.

And i remove the spinlock which is logical not a part of the fifo and
should be handled outside if necessary.

   
> If you split out every logical change into a separate patch,
> you can easily show how to subsequently make use of that.
> That also avoids the problem of adding functions that end up
> being unused.
> 

> Submitting patches would also make it easier to review than
> a rewrite.
> 

Agree, but the code is very tiny and the functionality depends on the
whole. Since many of the functions are inlines, which will not generate
any code until there are used. So the kernel will not be bloated.

> > Third: The old API did not have a kfifo_to_user oder a kfifo_from_user
> > functionality, so everybody wo need to store userspace data must write
> > it own version of this.
> 
> That sounds like a feature that can be easily separated from the
> incompatible API changes.
> 
> > Fourth: We don't discus about a havy API change, it is more subtle. And
> > it doesn't blow up the kernel, okay, a little little bit. But i am sure
> > that this well be gained back, if/when developer use this new API.    
> 
> Can you separate the incompatible API changes from the compatible
> extensions?
> 

No, thats not makes not real sense. If i do this i have exactly the old
API. Again, the API is not really incompatible, the change is from the
view of the old API very tiny.
 
> 	Arnd <><

Stefani


