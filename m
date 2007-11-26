Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbXKZTz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbXKZTz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 14:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbXKZTzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 14:55:20 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:38183 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbXKZTzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 14:55:19 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 26 Nov 2007 11:55:15 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
In-Reply-To: <474B1960.2030104@zytor.com>
Message-ID: <Pine.LNX.4.64.0711261111110.22680@alien.or.mcafeemobile.com>
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com>
 <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com>
 <474323CA.9030306@zytor.com> <alpine.LFD.0.9999.0711261003290.5869@woody.linux-foundation.org>
 <20071126184528.GA16071@elte.hu> <474B1960.2030104@zytor.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, H. Peter Anvin wrote:

> Ingo Molnar wrote:
> > 
> > So it's not like sys_indirect() would break some magic pristine state of a
> > flat parameter space - on the contrary, most of the nontrivial syscalls take
> > pointers to structures or pointers to streams of information. The parameter
> > count histogram i believe further underlines this point:
> > 
> >   #args   #syscalls
> >   -----------------
> >       0       22
> >       1       51
> >       2       83
> >       3       85
> >       4       40
> >       5       23
> >       6        8
> > 
> > the natural 'center' of function call parameter counts is around 1-4
> > parameters, and that is natural. (most operators that the human brain
> > prefers to operate with are like that - having higher complexity than that
> > often defeats the purpose of getting an API used by ... humans.)
> > 
> 
> I was preparing a response to Linus' email, but I really feel this needs to be
> addressed specifically.
> 
> When it comes to dealing with the operator-visible state, what matters is what
> happens on the API level, NOT on the system call level. Furthermore, the
> proposed sys_indirect interface just means that there are parameters hidden
> from immediately view, even though they fundamentally change the operation
> performed, and that it is much harder to correlate, say, the output of
> strace(1) with what actually happened in the program.  So from a
> *psychological* point of view, this seems to be an insane design choice.

I think there are two different issues. One is the proliferation of system 
calls, and the other is the sane design of internal kernel APIs.
The first one is not very interesting to me, since I don't have any strong 
opinions in either cases.
The second is the one I'd care most. I think that, whatever is the 
solution used to address the first, internal kernel APIs should be 
designed so that parameters flow down from the system call to the 
parameter's user code. IMO, besides very few cases where it could make 
some sense [*], setting some thread-global bits in the upper layer, to be 
magically picked up by code in the lower layers, does not lead to readable 
interfaces.



[*] Things that already read from a shared context, that is already 
    exposed to the user through some sort of set/get APIs.



- Davide


