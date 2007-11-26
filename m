Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbXKZTIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbXKZTIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 14:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbXKZTIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 14:08:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40927 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbXKZTIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 14:08:17 -0500
Message-ID: <474B1960.2030104@zytor.com>
Date: Mon, 26 Nov 2007 11:07:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com> <474323CA.9030306@zytor.com> <alpine.LFD.0.9999.0711261003290.5869@woody.linux-foundation.org> <20071126184528.GA16071@elte.hu>
In-Reply-To: <20071126184528.GA16071@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> So it's not like sys_indirect() would break some magic pristine state of 
> a flat parameter space - on the contrary, most of the nontrivial 
> syscalls take pointers to structures or pointers to streams of 
> information. The parameter count histogram i believe further underlines 
> this point:
> 
>   #args   #syscalls
>   -----------------
>       0       22
>       1       51
>       2       83
>       3       85
>       4       40
>       5       23
>       6        8
> 
> the natural 'center' of function call parameter counts is around 1-4 
> parameters, and that is natural. (most operators that the human brain 
> prefers to operate with are like that - having higher complexity than 
> that often defeats the purpose of getting an API used by ... humans.)
> 

I was preparing a response to Linus' email, but I really feel this needs 
to be addressed specifically.

When it comes to dealing with the operator-visible state, what matters 
is what happens on the API level, NOT on the system call level. 
Furthermore, the proposed sys_indirect interface just means that there 
are parameters hidden from immediately view, even though they 
fundamentally change the operation performed, and that it is much harder 
to correlate, say, the output of strace(1) with what actually happened 
in the program.  So from a *psychological* point of view, this seems to 
be an insane design choice.

	-hpa
