Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbYJZTdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbYJZTdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 15:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYJZTdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 15:33:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:49183 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbYJZTdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 15:33:12 -0400
Date: Sun, 26 Oct 2008 12:33:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davidel@xmailserver.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: kerneloops.org: 2.6.28-rc regression in epoll (list corruption)
Message-ID: <20081026123332.10a1941f@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0810261141350.5200@nehalem.linux-foundation.org>
References: <20081026112920.28e7dccc@infradead.org>
	<alpine.LFD.2.00.0810261141350.5200@nehalem.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008 11:58:06 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 26 Oct 2008, Arjan van de Ven wrote:
> >
> > This one is upcoming fast (and I just hit it as well)
> > 
> > http://www.kerneloops.org/searchweek.php?search=ep_poll_callback
> > 
> > seems epoll grew some list corruption....
> 
> It sounds very much like f337b9c58332bdecde965b436e47ea4c94d30da0
> ("epoll: drop unnecessary test") deleted a test that wasn't so
> unnecessary after all..
> 
> That ep_poll_callback() code is:
> 
>         /* If this file is already in the ready list we exit soon */
>         if (ep_is_linked(&epi->rdllink))
>                 goto is_linked;
> 
>         list_add_tail(&epi->rdllink, &ep->rdllist);
> 
> and the unnecessary test that was removed looks _very_ much like that
> kind of code.
> 
> Thomas? Davide?
> 
> And if somebody knows how to reproduce this reliably, it would be
> really good to hear if doing a revert on that thing just fixed it. It
> should revert cleanly - it's the only change to fs/eventpoll.c since
> 2.6.27.
> 

I did the revert and did the same thing I did before, and haven't seen
it yet.

(this is obviously a really small sample size on both sides of the
line, but it's at least not show it easily now while I saw it a few
times before.. after I fixed my Wifi and manually set the r8169 mac)
-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
