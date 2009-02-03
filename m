Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbZBCS3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbZBCS3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 13:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZBCS24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 13:28:56 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:40294 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbZBCS2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 13:28:55 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 3 Feb 2009 10:28:54 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 2/6] epoll keyed wakeups v2 - introduce new *_poll()
 wakeup macros
In-Reply-To: <20090203001401.cc960d4e.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0902031028080.23050@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.13601.1233518664.2> <20090203001401.cc960d4e.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, Andrew Morton wrote:

> On Sun, 01 Feb 2009 12:04:23 -0800 Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > +#define wake_up_nested_poll(x, m, s)					\
> > +do {									\
> > +	unsigned long flags;						\
> > +									\
> > +	spin_lock_irqsave_nested(&(x)->lock, flags, (s));		\
> > +	wake_up_locked_poll(x, m);					\
> > +	spin_unlock_irqrestore(&(x)->lock, flags);			\
> > +} while (0)
> 
> I had to go and find the callsite to work out the type of `x' :(
> 
> - this macro can be passed the address of any structure which has a
>   `spinlock_t lock;' in it, which seems strange.

That'd be a wait_queue_head_t*. Maybe better turn this into functions, I 
agree.


- Davide


