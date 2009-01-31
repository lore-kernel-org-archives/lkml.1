Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZAaDvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZAaDvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZAaDvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 22:51:16 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:40371 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZAaDvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 22:51:16 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 30 Jan 2009 19:50:56 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>
Subject: Re: [patch 3/7] epoll keyed wakeups - introduce key-aware wakeup
 macros
In-Reply-To: <20090131033035.GA26640@elte.hu>
Message-ID: <alpine.DEB.1.10.0901301950020.31741@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.16376.1233372317.3> <20090131033035.GA26640@elte.hu>
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
> * Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > +#define wake_up(x)			kwake_up(x, NULL)
> > +#define wake_up_nr(x, nr)		kwake_up_nr(x, nr, NULL)
> > +#define wake_up_all(x)			kwake_up_all(x, NULL)
> > +#define wake_up_locked(x)		kwake_up_locked(x, NULL)
> > +
> > +#define wake_up_interruptible(x)	kwake_up_interruptible(x, NULL)
> > +#define wake_up_interruptible_nr(x, nr)	kwake_up_interruptible_nr(x, nr, NULL)
> > +#define wake_up_interruptible_all(x)	kwake_up_interruptible_all(x, NULL)
> > +#define wake_up_interruptible_sync(x)	kwake_up_interruptible_sync(x, NULL)
> 
> i like the patchset - nice work!
> 
> One minor worry i have: these wakeup calls are _very_ common in the 
> kernel, and this patch adds an extra parameter to it that is unused (NULL) 
> in 99% of the cases.
> 
> Would be nice to see the kernel image size increase due to this change 
> (which gives a good measure about how much of an issue this is).
> 
> If it's of any worrying level, it might make sense to keep the original 
> functions untouched, and introduce a second entry point that has one more 
> parameter. Ok?

Fine by me. Any preference for names?



- Davide


