Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbYJTQjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbYJTQjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYJTQi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:38:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996AbYJTQi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:38:58 -0400
Date: Mon, 20 Oct 2008 09:37:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Roland Dreier <rdreier@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
In-Reply-To: <20081018082209.GA24220@elte.hu>
Message-ID: <alpine.LFD.2.00.0810200933470.3518@nehalem.linux-foundation.org>
References: <20081017171139.GA1792@elte.hu> <ada3aiv9k6j.fsf@cisco.com> <20081017180523.GA11590@elte.hu> <adatzbbrrcf.fsf@cisco.com> <20081017191202.GA5396@elte.hu> <adaiqrrrp2h.fsf@cisco.com> <20081018082209.GA24220@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Oct 2008, Ingo Molnar wrote:
> 
> thx, you are right - fixed it via the patch below.

Hell no.

The old code was correct. Your code is shit. And you didn't fix 
_anything_.

>  	case 5:
>  		*(int *)to = *(int *)from;
> -		*((short *)to + 3) = *((short *)from + 3);
> +		*((char *)(to + 3)) = *((char *)(from + 3));
>  		return to;

Are you just making changes by randomly inserting and deleting characters 
until you don't see warnings? Or what?

That thing is supposed to be a 5-byte memcpy. Not a "take a random byte 
from a random location and move it to another random location". That would 
be "randcpy()", not "memcpy()".

I don't want to see obvious and shitty crap like this. I don't want to 
pull from people who write code with some "random walk" algorithm.

F*ck me, what's wrong with you people? THAT CODE WAS NOT BUGGY. If it 
causes a warning, it is because SOME CALLER used a 5-byte memcpy() on 
something that gcc thought was just four bytes in size.

Ingo, I'm not going to pull _anything_ from you.

			Linus
