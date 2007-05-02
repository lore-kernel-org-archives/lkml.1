Return-Path: <linux-kernel-owner+w=401wt.eu-S1766939AbXEBULd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766939AbXEBULd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766942AbXEBULc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:11:32 -0400
Received: from haxent.com ([65.99.219.155]:4967 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766941AbXEBULb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:11:31 -0400
Message-ID: <4638F06D.5030603@haxent.com.br>
Date: Wed, 02 May 2007 17:11:25 -0300
From: Davi Arnaut <davi@haxent.com.br>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 00/22] pollfs: filesystem abstraction for pollable objects
References: <20070502052235.914764000@haxent.com.br> <20070501230529.424f17c6.akpm@linux-foundation.org> <Pine.LNX.4.64.0705021010390.7176@alien.or.mcafeemobile.com> <4638CECE.6060409@haxent.com.br> <Pine.LNX.4.64.0705021053040.7176@alien.or.mcafeemobile.com> <4638DD76.7090904@haxent.com.br> <Pine.LNX.4.64.0705021159340.7176@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0705021159340.7176@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Wed, 2 May 2007, Davi Arnaut wrote:
>
>   
>> So in this case I may borrow some signalfd code :-) I really like the
>> signalfd approach, but IMHO the code is quite ugly and duplicates
>> a lot of hairy code.
>>     
>
> Ugly, really? Please ...
>
> +	while (!mutex_trylock(&evs->mutex))
> +		cpu_relax();
>
>   

I would call that a "creative way to spin a mutex" .

> So, let's see. The whole things adds an unneeded (read "empty") extra 
> layer of indirections over the existing file_operations. 

"Empty" ? It handles the non-blocking code, event waiting, filp
setup. It's a affordable extra thin layer.

> Timerfd added the 
> return of the structure (because "developer may need it"), that wants 
> extra compat too. 

I bet the pltimer/plsignal compat code will be smaller/cleaner then
the timerfd/signalfd. Will post soon.

> Your signal code does not handle things that is supposed 
> to be handling (easy to write clean code when the code does not actually 
> do what is supposed to be doing), and you'll be sucking code from 
> signalfd.

As if sucking code from signalfd is a bad thing.

>  On top of that, it returns a structure that needs compat too. 
> AIO code added an extra unnecessary wrapper over AIO native calls (by 
> literally calling sys_io_*). And the compat on sys_read/sys_write I 
> guess will be funny to watch.

I hope you enjoy it :-)

>  So what does your code effectively adds that 
> is useful in some way? Undocumented and testcase-less code?
> As I see it, your code badly copies exiting one, and adds uneeded 
> infrastrcture/functionality.
>   

If you don't  remember i mailed you the patches back on 03/08/2007.
It's definitely not a copy.

> See, I really wouldn't care, if you'd keep the "ugly" word for yourself.
>   

its a matter of taste and i'm entitled to a bad one every once in a 
while :-)

> Actually, I really care only about the functionality, so I leave the whole 
> ball into Andrew's hands ;)
>   

Anyway, I didn't expect to move forward with your blessing but your comments
are appreciated.

Andrew, If you see fit, go ahead with signalfd. Anyway, i will cook up a 
a new version
for tomorrow.

--
Davi Arnaut
