Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbZHCSXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbZHCSXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbZHCSXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:23:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56765 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbZHCSXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:23:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: [RFC 0/2] new kfifo API
Date: Mon, 3 Aug 2009 20:23:15 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.98; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, open-iscsi@googlegroups.com,
       Mike Christie <michaelc@cs.wisc.edu>
References: <1249306755.8358.8.camel@wall-e> <200908031642.15136.arnd@arndb.de> <1249312458.23559.25.camel@wall-e>
In-Reply-To: <1249312458.23559.25.camel@wall-e>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908032023.15355.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18hz8qxRx2Tv0n19WcIM04o32733o0k1Jm5LEt
 Y8qjISLXXcpI6pB+bUSpjRQaxE8cZlc1vp4l2NCdv475iHdnLI
 jjxRJJSjyYE1p57+mVVFw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Stefani Seibold wrote:
> Am Montag, den 03.08.2009, 16:42 +0200 schrieb Arnd Bergmann:
> > My guess is that more importantly
> > 
> > - few people so far needed the functionality.
> 
> This is not true, that is only your view. Don't speak for other people.
> A lot of device driver developer has its own implement of a fifo. I have
> written a lot of device drivers for embedded system and i always missed
> a clean designed and implemented fifo API subsystem.

As I said, I was only guessing from the only evidence we both had, which
is the current use in the kernel. Your extrapolation was that it did
not get used much because of the quality of the existing API, my
extrapolation was that there is no need for it (at least I was
never looking for it in any of my drivers).

> > This sounds all nice, and your code looks clean and usable, but really,
> > what's your point?
> > 
> > If you have a new driver that will use all the new features, please
> > just tell us, that would make your point much clearer. Also, if
> > you can quantify an advantage (xxxx bytes code size reduce, yy%
> > performance improvement on Y benchmark) that would be really
> > helpful.
> > 
> 
> Yes, i have some drivers where i use a former version of the kfifo API.
> But the real advantage is not benchmarking.
>
> First if we have a useable kfifo API i think other developer will use
> it. And this will save memory.

Being able to simplify code is obviously good, but the normal
approach of doing it is to make it obvious in what ways. Exchanging
a whole API at once makes it unobvious what changes you do for which
purpose. 

If you split out every logical change into a separate patch,
you can easily show how to subsequently make use of that.
That also avoids the problem of adding functions that end up
being unused.

Submitting patches would also make it easier to review than
a rewrite.

> Third: The old API did not have a kfifo_to_user oder a kfifo_from_user
> functionality, so everybody wo need to store userspace data must write
> it own version of this.

That sounds like a feature that can be easily separated from the
incompatible API changes.

> Fourth: We don't discus about a havy API change, it is more subtle. And
> it doesn't blow up the kernel, okay, a little little bit. But i am sure
> that this well be gained back, if/when developer use this new API.    

Can you separate the incompatible API changes from the compatible
extensions?

	Arnd <><
