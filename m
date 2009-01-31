Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbZAaS5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbZAaS5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 13:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZAaS5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 13:57:44 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:39705 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZAaS5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 13:57:43 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 31 Jan 2009 10:57:37 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>
Subject: Re: [patch 3/7] epoll keyed wakeups - introduce key-aware wakeup
 macros
In-Reply-To: <20090131130646.GA3986@elte.hu>
Message-ID: <alpine.DEB.1.10.0901311052550.18888@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.16376.1233372317.3> <20090131033035.GA26640@elte.hu> <alpine.LFD.2.00.0901301953280.3150@localhost.localdomain> <20090131130646.GA3986@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jan 2009, Ingo Molnar wrote:

> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Sat, 31 Jan 2009, Ingo Molnar wrote:
> > > 
> > > Would be nice to see the kernel image size increase due to this change 
> > > (which gives a good measure about how much of an issue this is).
> > 
> > Ingo, I don't think you have looked at that header file for a while.
> > 
> > It's already doing that, Davide just changed the names a bit:
> > 
> > 	#define wake_up_interruptible(x)        __wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
> > 
> > and the extra parameter is already there in the caller.
> 
> Yeah, indeed - i should have noticed the absense of new function 
> prototypes in the patch ... and in any case i shouldnt post at 4am ;)
> 
> > (Yeah, Davide did add it to __wake_up_locked and __wake_up_sync, but 
> > those are really not the common cases).
> > 
> > Sure, we can change those #define's to be actual functions (and perhaps 
> > not export the low-level __wake_up() functions at all), since it's true 
> > that it would probably shrink the kernel size, but that is really a 
> > totally independent issue from the whole epoll wakeups thing.
> 
> Yeah. Will have a look at that independently of Davide's patch.

The ones with an extra parameter are "sync" and "locked". The 
simple __wake_up() ones, already had the parameter.
So your idea would be to have __wake_up_locked_XXX and __wake_up_sync_XXX 
instead of adding an extra parameter, no?
If yes, what about XXX? "key"?



- Davide


