Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbZAaTIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbZAaTIw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 14:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbZAaTIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 14:08:43 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:56539 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbZAaTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 14:08:42 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 31 Jan 2009 11:08:40 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: wli@movementarian.org
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 3/7] epoll keyed wakeups - introduce key-aware wakeup
 macros
In-Reply-To: <20090131045733.GA26410@movementarian.org>
Message-ID: <alpine.DEB.1.10.0901311104180.18888@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.16376.1233372317.3> <alpine.LFD.2.00.0901301949110.3150@localhost.localdomain> <20090131045733.GA26410@movementarian.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009, wli@movementarian.org wrote:

> On Fri, Jan 30, 2009 at 07:49:26PM -0800, Linus Torvalds wrote:
> > But even more I dislike the notion of this being a "key". It's not. It's 
> > about poll events, nothing more. So renaming it to "_key()" in no way 
> > helps.
> > Yes, _internally_ we send that "void *key" around, and then leave it to 
> > lower levels to agree about how it is used, but at the level _you_ then 
> > use it, that is no longer the case. When you do a 
> > 	kwake_up_interruptible(&tty->write_wait, POLLOUT);
> > that has _nothing_ to do with "keys" any more. So the 'k' prefix is wrong 
> > and really odd-looking, but a '_key' postfix wouldn't be much better 
> > either. Because when you pass in POLLOUT, you're not using it as a key, 
> > you are very much using it as a poll-specific thing.
> > So the naming should match that. I suspect a '_poll' postfix (or a 'poll_' 
> > prefix would work and make sense.
> 
> The filtered wakeup code uses some notion of a key already. There, the
> key is to route wakeups to recipients associated with the correct
> object. Here, the objects are known in advance. The wakeup is to give
> them some particular message in which they may not necessarily be
> interested. Names indicative of that (e.g. *_msg/msg_*) would clarify
> the distinction between it and the filtered wakeup code used for pages.

I had thought of giving the void* some structure, besides being a cast 
from an event mask, so that later on we'd be able to eventually embed 
more information in the wakeup. Dunno if worth it.



- Davide


