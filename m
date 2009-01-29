Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbZA2S1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbZA2S1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbZA2S1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:27:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135AbZA2S1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:27:36 -0500
Date: Thu, 29 Jan 2009 10:27:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: Re: [patch 1/2] epoll fix own poll()
Message-Id: <20090129102726.5f4a0040.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0901290956530.15448@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901271251310.20262@alien.or.mcafeemobile.com>
	<20090129000120.da7d249d.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0901290956530.15448@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009 10:16:31 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:

> On Thu, 29 Jan 2009, Andrew Morton wrote:
> 
> > >  fs/eventpoll.c |  510 +++++++++++++++++++++++++++++++++------------------------
> > >  1 file changed, 304 insertions(+), 206 deletions(-)
> > 
> > Holy cow man, this patch is HUGE!  I don't have a clue what it does nor
> > how it does it.  I'd be somewhat scared to merge it into 2.6.29.  How
> > serious is this bug?
> 
> It is a 3 in a scale of 5. The reason the patch is HUGE is because the 
> epoll ->poll() code now has to perform an operation similar to what was 
> performing in epoll_wait(), and under the same constraints (check out for 
> recursions and too long nesting chains) that were checked in the wakeups.
> So instead of duplicating the code, I made the two core operations such 
> that they get a function pointer for the core operation they have to 
> perform. That required some code movement.
> 

But which kernel version are you looking to get this merged into?

> 
> You always confuse me with your comments. Before you comment, then you 
> merge w/out giving me time to change.
>

yeah, I often do that.  If I see nothing fatal in the patch I'll merge
it so that it gets a bit of testing and so that it doesn't get
forgotten about.  Especially if it's a bugfix.

Sometimes I'll send a reply and the originator goes to sleep for weeks,
and stuff could even get lost.  I hate losing stuff.  I'll mark the patch
as "needs an update" in the series file so I don't accidentally merge it
upstream.

> Would you like the updated patches?

Sure, when convenient.
