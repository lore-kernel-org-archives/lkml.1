Return-Path: <linux-kernel-owner+w=401wt.eu-S1751903AbXCCLDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbXCCLDt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 06:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbXCCLDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 06:03:49 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:59875 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbXCCLDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 06:03:48 -0500
Date: Sat, 3 Mar 2007 14:03:27 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ihar `Philips` Filipau <thephilips@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070303110327.GA11992@2ka.mipt.ru>
References: <efa6f5910703021120ia0b8d18ne0c806eb2e73da4c@mail.gmail.com> <20070303103427.GC22557@2ka.mipt.ru> <efa6f5910703030258ne76cd8as8a3900fc22456a91@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <efa6f5910703030258ne76cd8as8a3900fc22456a91@mail.gmail.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Sat, 03 Mar 2007 14:03:50 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 11:58:17AM +0100, Ihar `Philips` Filipau (thephilips@gmail.com) wrote:
> On 3/3/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> >On Fri, Mar 02, 2007 at 08:20:26PM +0100, Ihar `Philips` Filipau 
> >(thephilips@gmail.com) wrote:
> >> I'm not well versed in modern kernel development discussions, and
> >> since you have put the thing into the networked context anyway, can
> >> you please ask on lkml why (if they want threadlets solely for AIO)
> >> not to implement analogue of recv(*filedes*, b, l, MSG_DONTWAIT).
> >> Developers already know the inteface, socket infrastructure is already
> >> in kernel, etc. And it might do precisely what they want: access file
> >> in disk cache - just like in case of socket it does access recv buffer
> >> of socket. Why bother with implicit threads/waiting/etc - if all they
> >> want some way to probe cache?
> >
> >Threadlets can work with any functionas a base - if it would be
> >recv-like it will limit possible case for parallel programming, so you
> >can code anything in threadlets - it is not only about IO.
> >
> 
> Ingo defined them as "plain function calls as long as they do not block".
> 
> But when/what function could block?
> 
> (1) File descriptors. Read. If data are in cache it wouldn't block.
> Otherwise it would. Write. If there is space in cache it wouldn't
> block. Otherwise it would.
> 
> (2) Network sockets. Recv. If data are in buffer they wouldn't block.
> Otherwise they would. Send. If there is space in send buffer it
> wouldn't block. Otherwise it would.
> 
> (3) Pipes, fifos & unix sockets. Unfortunately gain nothing since the
> reliable local communication used mostly for control information
> passing. If you have to block on such socket it most likely important
> information anyway. (e.g. X server communication or sql query to SQL
> server). (Or even less important here case of shell pipes.) And most
> users here are all single threaded and I/O bound: they would gain
> nothing from multi-threading - only PITA of added locking.
> 
> What I'm trying to get to: keep things simple. The proposed
> optimization by Ingo does nothing else but allowing AIO to probe file
> cache - if data there to go with fast path. So why not to implement
> what the people want - probing of cache? Because it sounds bad? But
> they are in fact proposing precisely that just masked with "fast
> threads".

There can be other parts than just plain recv/read syscalls - you can
create a logical processing entity and if it will block (as a whole, no
matter where), the whole processing will continue as a new thread.
And having different syscall to warm cache can end up in cache flush in
between warming and processing itself.
 
> -- 
> Don't walk behind me, I may not lead.
> Don't walk in front of me, I may not follow.
> Just walk beside me and be my friend.
>    -- Albert Camus (attributed to)

-- 
	Evgeniy Polyakov
