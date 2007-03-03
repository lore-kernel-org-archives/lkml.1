Return-Path: <linux-kernel-owner+w=401wt.eu-S1751743AbXCCK6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbXCCK6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 05:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbXCCK6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 05:58:24 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:36795 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbXCCK6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 05:58:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RrWTiCTkyPhYGa2f6BN/WsqeV1s7CgPqBxC2wVtUq8812zaBtVSVWQa6qLKkuzxOiSxHFSlhhe5V/GuL85NUkiWd4uM4RQoiK+ndqabj6GqTx4ce/t6NFTJAzTG8G9Y9RQU9zhEYTc2t1CTGdQLwqEL1f4feH6w7ZsWdi4XYQpI=
Message-ID: <efa6f5910703030258ne76cd8as8a3900fc22456a91@mail.gmail.com>
Date: Sat, 3 Mar 2007 11:58:17 +0100
From: "Ihar `Philips` Filipau" <thephilips@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070303103427.GC22557@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <efa6f5910703021120ia0b8d18ne0c806eb2e73da4c@mail.gmail.com>
	 <20070303103427.GC22557@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/3/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> On Fri, Mar 02, 2007 at 08:20:26PM +0100, Ihar `Philips` Filipau (thephilips@gmail.com) wrote:
> > I'm not well versed in modern kernel development discussions, and
> > since you have put the thing into the networked context anyway, can
> > you please ask on lkml why (if they want threadlets solely for AIO)
> > not to implement analogue of recv(*filedes*, b, l, MSG_DONTWAIT).
> > Developers already know the inteface, socket infrastructure is already
> > in kernel, etc. And it might do precisely what they want: access file
> > in disk cache - just like in case of socket it does access recv buffer
> > of socket. Why bother with implicit threads/waiting/etc - if all they
> > want some way to probe cache?
>
> Threadlets can work with any functionas a base - if it would be
> recv-like it will limit possible case for parallel programming, so you
> can code anything in threadlets - it is not only about IO.
>

Ingo defined them as "plain function calls as long as they do not block".

But when/what function could block?

(1) File descriptors. Read. If data are in cache it wouldn't block.
Otherwise it would. Write. If there is space in cache it wouldn't
block. Otherwise it would.

(2) Network sockets. Recv. If data are in buffer they wouldn't block.
Otherwise they would. Send. If there is space in send buffer it
wouldn't block. Otherwise it would.

(3) Pipes, fifos & unix sockets. Unfortunately gain nothing since the
reliable local communication used mostly for control information
passing. If you have to block on such socket it most likely important
information anyway. (e.g. X server communication or sql query to SQL
server). (Or even less important here case of shell pipes.) And most
users here are all single threaded and I/O bound: they would gain
nothing from multi-threading - only PITA of added locking.

What I'm trying to get to: keep things simple. The proposed
optimization by Ingo does nothing else but allowing AIO to probe file
cache - if data there to go with fast path. So why not to implement
what the people want - probing of cache? Because it sounds bad? But
they are in fact proposing precisely that just masked with "fast
threads".


-- 
Don't walk behind me, I may not lead.
Don't walk in front of me, I may not follow.
Just walk beside me and be my friend.
    -- Albert Camus (attributed to)
