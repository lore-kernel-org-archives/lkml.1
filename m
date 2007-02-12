Return-Path: <linux-kernel-owner+w=401wt.eu-S964970AbXBLSPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964970AbXBLSPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964971AbXBLSPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:15:10 -0500
Received: from comtv.ru ([217.10.32.17]:48207 "EHLO comtv.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964970AbXBLSPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:15:09 -0500
X-UCL: actv
Date: Mon, 12 Feb 2007 21:15:34 +0300 (MSK)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@home.oyster.ru
To: Andrew Burgess <aab@cichlid.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: CPU load
In-Reply-To: <200702121657.l1CGvRh5010463@cichlid.com>
Message-ID: <Pine.LNX.4.64.0702122105400.2345@home.oyster.ru>
References: <200702121657.l1CGvRh5010463@cichlid.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Feb 2007, Andrew Burgess wrote:

> On 12/02/07, Vassili Karpov <av1474@comtv.ru> wrote:
>>
>> How does the kernel calculates the value it places in `/proc/stat' at
>> 4th position (i.e. "idle: twiddling thumbs")?
>>
> ..
>>
>> Later small kernel module was developed that tried to time how much
>> time is spent in the idle handler inside the kernel and exported this
>> information to the user-space. The results were consistent with our
>> expectations and the output of the test utility.
> ..
>> http://www.boblycat.org/~malc/apc
>
> Vassili
>
> Could you rewrite this code as a kernel patch for
> discussion/inclusion in mainline? I and maybe others would
> appreciate having idle statistics be more accurate.

I really don't know how to approach that, what i do in itc.c is ugly
to say the least (it's less ugly on PPC, but still).

There's stuff there that is very dangerous, i.e. entering idle handler
on SMP and simultaneously rmmoding the module (which surprisingly
never actually caused any bad things on kernels i had (starting with
2.6.17.3), but paniced on Debians 2.6.8). Safety nets were added but i
don't know whether they are sufficient. All in all what i have is a
gross hack, but it works for my purposes.

Another thing that keeps bothering me (again discovered with this
Debian kernel) is the fact that PREEMPT preempts idle handler, this
just doesn't add up in my head.

So to summarize: i don't know how to properly do that (so that it
works on all/most architectures, is less of a hack, has no negative
impact on performance, etc)

But i guess what innocent `smallhog.c' posted earlier demonstrated -
is that something probably ought to be done about it, or at least
the current situation documented.

-- 
vale
