Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbZA3Cw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbZA3Cw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 21:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZA3CwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 21:52:17 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:38060 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZA3CwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 21:52:17 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 29 Jan 2009 18:52:14 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] epoll fix own poll()
In-Reply-To: <200901300329.35641.pisa@cmp.felk.cvut.cz>
Message-ID: <alpine.DEB.1.10.0901291849350.16141@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901271251310.20262@alien.or.mcafeemobile.com> <alpine.DEB.1.10.0901291030390.15448@alien.or.mcafeemobile.com> <20090129103715.2d3a8274.akpm@linux-foundation.org> <200901300329.35641.pisa@cmp.felk.cvut.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009, Pavel Pisa wrote:

> So if there exists applications using epoll, they could waste sometimes
> most of CPU time without without any visible error indication. 
> The most critical problem is, that even epoll_wait() on epoll set, which
> reports falsely ready condition, doe not clear that state for outer
> loop and event waiting mechanism. So in theory, some patch with
> smaller scale and impact which only ensures, that event is not falsely
> reported even after epoll_wait() call would be enough to save system
> from busyloop load. The false wakeup and wasted call to epoll_wait ()
> with no event returned is not so big problem.
> 
> On the other hand, most of today applications are based on GLIB (poll),
> Qt (for pure Qt select) or libevent (not cascaded poll/epoll), which all are
> not prone to this problem. Even for my intended use, my code can
> work without cascading and if cascading is required, then standard
> poll and  then moving of events triggers into GLIB loop is enough
> for 10 to 100 FDs. So actual real severity is not so high.
> 
> I am happy that Davide has found fix to the problem, but even if the
> fix gets into 2.6.29 there would be older kernels for years there
> and use of epoll cascading would be problem. So I see as most
> important, that information about problem is known and does not
> surprise others. It would be great, if there is found safe way,
> how to ensure even without fix to revive from ill situation
> by some userspace action on older kernels.
> I do not see yet, why call to epoll_wait() does not to clean
> "rdllist" on unpatched kernel. 

Epoll cleans, even on older kernels, the rdllist from spurious events, 
upon epoll_wait(). If later on you get another spurious event, you fall 
into the same condition. Or, can you send a minimal code snippet that 
shows this not being true for older kernels?


- Davide


