Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbZIQAxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbZIQAxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 20:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZIQAxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 20:53:09 -0400
Received: from smtp-gw51.mailanyone.net ([208.70.128.77]:57261 "EHLO
	smtp-gw51.mailanyone.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbZIQAxI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 20:53:08 -0400
From: "Gilad Benjamini" <gilad@altornetworks.com>
To: "'Bryan Donlan'" <bdonlan@gmail.com>
Cc: "'Davide Libenzi'" <davidel@xmailserver.org>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <023c01ca3724$9f90fcb0$deb2f610$@com> <alpine.DEB.2.00.0909161656150.3124@makko.or.mcafeemobile.com> 	<024601ca372d$09ad9fb0$1d08df10$@com> <alpine.DEB.2.00.0909161726090.3124@makko.or.mcafeemobile.com> 	<024701ca372f$81412040$83c360c0$@com> <3e8340490909161745h5c58c165j1726c3433df3baeb@mail.gmail.com>
In-Reply-To: <3e8340490909161745h5c58c165j1726c3433df3baeb@mail.gmail.com>
Subject: RE: epoll and closed file descriptors
Date: Wed, 16 Sep 2009 17:53:05 -0700
Message-ID: <024801ca3731$38833ad0$a989b070$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Aco3MC3PRsgeMR0jRiC+mmcpxP1V0wAAMAnA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: epoll and closed file descriptors
> 
> On Wed, Sep 16, 2009 at 8:40 PM, Gilad Benjamini
> <gilad@altornetworks.com> wrote:
> > Davide wrote:
> >> On Wed, 16 Sep 2009, Gilad Benjamini wrote:
> >>
> >> > I would, but epoll is preventing me from doing so.
> >> > Early in sys_epoll_ctl there are these lines
> >> >
> >> >   file = fget(epfd);
> >> >   if (!file)
> >> >     goto error_return;
> >> >
> >> > Leaving me in a kind of dead lock
> >>
> >> The 'epfd' in there, is the _epoll fd_, which, if fget() fails,
> means
> >> you
> >> close it.
> >> You see likely failing the 'tfile = fget(fd)' (of course, you closed
> >> it),
> >> so if someone else keeps the socket open and you have no chance in
> >> telling
> >> it to drop it (really?), you need to remove the socket from the set
> >> before
> >> closing it.
> >>
> >>
> >>
> >> - Davide
> >
> > My bad. I meant to quote the line that you mentioned.
> > I agree that the right thing to do is to remove the fd from epoll
> before
> > closing it.
> > However, due to the way curl works, I cannot do that. Changing the
> curl code
> > doesn't seem trivial.
> >
> > Regardless, I still don't see how the kernel got into this situation,
> and if
> > this situation is valid, why it doesn't bail out of it.
> 
> epoll references the underlying file object; the fd is used _only_ to
> obtain this file object, and then never used again. Determining when
> the fd goes away then requires iterating over all fds, and since epoll
> was designed to avoid doing exactly that, it isn't an acceptable
> solution.

Regarding bailing out of the situation, I see the logic in your answer.
What about the first part ? Any ideas how the kernel actually got into that
tight spot ?
Looking into the code I can't find a path that can lead into this situation.




