Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbZIQAkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbZIQAkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 20:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZIQAku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 20:40:50 -0400
Received: from smtp-gw51.mailanyone.net ([208.70.128.77]:50263 "EHLO
	smtp-gw51.mailanyone.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbZIQAku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 20:40:50 -0400
From: "Gilad Benjamini" <gilad@altornetworks.com>
To: "'Davide Libenzi'" <davidel@xmailserver.org>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <023c01ca3724$9f90fcb0$deb2f610$@com> <alpine.DEB.2.00.0909161656150.3124@makko.or.mcafeemobile.com> <024601ca372d$09ad9fb0$1d08df10$@com> <alpine.DEB.2.00.0909161726090.3124@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.0909161726090.3124@makko.or.mcafeemobile.com>
Subject: RE: epoll and closed file descriptors
Date: Wed, 16 Sep 2009 17:40:49 -0700
Message-ID: <024701ca372f$81412040$83c360c0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Aco3LglyZBqj6FY6Rei0QkA/YooliwAAQKwQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide wrote:
> On Wed, 16 Sep 2009, Gilad Benjamini wrote:
> 
> > I would, but epoll is preventing me from doing so.
> > Early in sys_epoll_ctl there are these lines
> >
> >   file = fget(epfd);
> >   if (!file)
> >     goto error_return;
> >
> > Leaving me in a kind of dead lock
> 
> The 'epfd' in there, is the _epoll fd_, which, if fget() fails, means
> you
> close it.
> You see likely failing the 'tfile = fget(fd)' (of course, you closed
> it),
> so if someone else keeps the socket open and you have no chance in
> telling
> it to drop it (really?), you need to remove the socket from the set
> before
> closing it.
> 
> 
> 
> - Davide

My bad. I meant to quote the line that you mentioned.
I agree that the right thing to do is to remove the fd from epoll before
closing it.
However, due to the way curl works, I cannot do that. Changing the curl code
doesn't seem trivial.

Regardless, I still don't see how the kernel got into this situation, and if
this situation is valid, why it doesn't bail out of it.


