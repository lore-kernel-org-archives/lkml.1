Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbXFDS0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbXFDS0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756327AbXFDS0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:26:48 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:26068 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbXFDS0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:26:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qetBaMSDI8M/v+seEqx5PUU4dipFmD0ls9kSWDS1GQr3FnqvvSsIceWPo/nrlY38MFkoc49cmwSWSzmQoXm6XVNIXImgZn2JBvjepL8yHykbYqMK2QFAgdfz7bTRECUr4BXdzSp2FjXCt/nrZaOXsgvRXd2ItVGyq0cA/vnz7jU=
Message-ID: <4cefeab80706041126y5f12402cl61b72ec101dd7915@mail.gmail.com>
Date: Mon, 4 Jun 2007 23:56:46 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Richard Purdie" <rpurdie@openedhand.com>
Subject: Re: [PATCH -mm 0/5] LZO and swap write failure patches for -mm
Cc: "Daniel Hazelton" <dhazelton@enter.net>, akpm <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <1180975976.6313.133.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1180971378.6313.72.camel@localhost.localdomain>
	 <200706041214.38017.dhazelton@enter.net>
	 <1180975976.6313.133.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Richard Purdie <rpurdie@openedhand.com> wrote:
> On Mon, 2007-06-04 at 12:14 -0400, Daniel Hazelton wrote:
> > On Monday 04 June 2007 11:36:18 Richard Purdie wrote:
> > I have been involved in benchmarking and testing that stripped down and
> > kernel-style version and cannot recall any mention of said alignment errors.
> > Perhaps I was removed from the CC: list - could you point me at them?
>
> I've forwarded you the full mail. To quote Nitin Gupta:
>
> > The author (Markus Oberhumer) of LZO  provided these comments for this
> > patch:
> [...]
> > I've only briefly looked over it, but it's obvious that your version
> > does not work on architechtures which do not allow unaligned access
> > (arm, mips, ...).
> [...]
> > Still a lot to do...
>
> So its author admits it isn't ready yet. I'm not saying that code is bad
> or shouldn't be included, just that we've ascertained it isn't ready
> *yet*. Which brings us back to my last mail and its proposal.
>


> > If there *are* memory alignment issues, why not fix them in that tiny
> > code rather than pushing a different version of the code into the
> > kernel that is
> > 1) Not kernel style and 2) bloated?
>

This is exactly what I have been saying.

> The zlib code isn't kernel style and is arguably bloated, perhaps we
> should remove that?

I don't know - I don't use zlib.
We can make LZO cleaner and perhaps faster. This will be good.

>
> If Nitin or others can fix that patch, fine but I can't afford the time
> to do it and until those issues are fixed, it isn't ready.
>

Yes. Many projects require LZO support and it might be getting
frustrating to delay  full-and-final code in kernel. I have been
extremely busy these days so I could not follow-up with authors
comments - also considering that some people want LZO patch split-up
into patch series which is highly cumbersome and time consuming in
this case.

I hoped that all of us can look into valuable feedback from author and
correct the issues he pointed out. This code duplication is really
pointless.

> Also, Nitin has already claimed several times that he's made no
> functional changes to that code only to find that actually there are
> functional changes. That does give rise to concern (not least for
> security). There are ways to address this but I don't have time to do it
> so it needs someone, preferably independent who has.
>

Yes there might still be problems - that is why I posted as RFC. I got
useful comments and the code is improving. Going for such fork might
be pain initially but IMHO its worth it. My idea for this 'fork' is
not just clean-ups but potential optimizations that such cleanups
usually bring along. I do not think there will be major overhauls in
such mature de/compression implementations so I believe its okay to go
for such 'fork' for sake of cleaner and perhaps faster code.

> > Unless you can clearly point out those "memory alignment" issues in
> > the
> > kernel-style code of the other LZO implementation that was posted as
> > an RFC I
> > have to say this: stop the FUD.
>
> This is not FUD, I've actually done things to help the other LZO
> implementation forward but my available time to help is limited.
>

I have identified those memory alignment issues and working on same.
Due to time constraints it might take me a bit longer.

> Note that I am not the only person to have expressed concerns with the
> alternative LZO implementation and some questions raised by others as
> well as myself regarding some of the code differences still remain
> unanswered too.

Again, I am working on improving the code as per feedback. This is
what I expect from RFC. Many people raised concerns regarding
bloatware in your patch too, including me.


Regards,
Nitin
