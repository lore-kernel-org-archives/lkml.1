Return-Path: <linux-kernel-owner+w=401wt.eu-S965114AbXBFAPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965114AbXBFAPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965121AbXBFAPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:15:35 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4179 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965114AbXBFAPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:15:34 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 5 Feb 2007 16:15:31 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: David Miller <davem@davemloft.net>
cc: zach.brown@oracle.com, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, suparna@in.ibm.com, bcrl@kvack.org
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <20070205.134442.85686980.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0702051531390.14453@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0702021525370.5219@alien.or.mcafeemobile.com>
 <EDD3B5A9-9EAB-4E0A-BE1F-3B73C3870DC8@oracle.com>
 <Pine.LNX.4.64.0702051022170.14453@alien.or.mcafeemobile.com>
 <20070205.134442.85686980.davem@davemloft.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007, David Miller wrote:

> From: Davide Libenzi <davidel@xmailserver.org>
> Date: Mon, 5 Feb 2007 10:24:34 -0800 (PST)
> 
> > Yes, no need for the above. We can just host a poll/epoll in an async() 
> > operation, and demultiplex once that gets ready.
> 
> I can hear Evgeniy crying 8,000 miles away.
> 
> I strongly encourage a lot of folks commenting in this thread to
> familiarize themselves with kevent and how it handles this stuff.  I
> see a lot of suggestions for things he has totally implemented and
> solved already in kevent.

David, I'm sorry but I only briefly looked at the work Evgeniy did on 
kevent. So excuse me if I say something broken in the next few sentences.
Zab's async syscall interface is a pretty simple one. It accepts the 
syscall number, the parameters for the syscall, and a cookie. It returns a 
syscall result code, and your cookie (that's the meat of it, at least). 
IMO its interface should be optimized for what it does.
Could this submission/retrieval be inglobated inside a "generic" 
submission/retrieval API? Sure you can. But then you end up having 
submission/event structures with 17 members, 3 of which are valid at each 
time. The API becomes more difficult to use IMO, because suddendly you 
have to know which field are good for each event you're submitting/fetching.
IMHO, genericity can be built in userspace, *if* one really wants it and, 
of course, provided that the OS gives you the tools to build it.
The problem before, was that it was hard to bridge something like poll/epoll 
with other "by nature" sync operations. Evgeniy kevent is one attempt, 
Zab's async is another one. IMO the async syscall is a *very poweful* one, 
since it allows for *total coverage* async support w/out "plugs" all over 
the kernel paths.
But as Zab said, the kernel implementation is more important ATM.




- Davide

