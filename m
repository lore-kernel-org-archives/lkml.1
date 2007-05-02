Return-Path: <linux-kernel-owner+w=401wt.eu-S1766897AbXEBRsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766897AbXEBRsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766949AbXEBRsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:48:01 -0400
Received: from haxent.com ([65.99.219.155]:1361 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766897AbXEBRsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:48:00 -0400
Message-ID: <4638CECE.6060409@haxent.com.br>
Date: Wed, 02 May 2007 14:47:58 -0300
From: Davi Arnaut <davi@haxent.com.br>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 00/22] pollfs: filesystem abstraction for pollable objects
References: <20070502052235.914764000@haxent.com.br> <20070501230529.424f17c6.akpm@linux-foundation.org> <Pine.LNX.4.64.0705021010390.7176@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0705021010390.7176@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Tue, 1 May 2007, Andrew Morton wrote:
>
>   
>> David, could you provide some feedback please?  The patches are stunningly
>> free of comments, but you used to do that to me pretty often so my sympathy
>> is limited ;)
>>     
>
> You bastard! :)
> Ok, from a brief look ...
>
> [general]
> The code adds an extra indirection over the already existing 
> file_operations, that IMO already sufficently abstract a file.
> The compat code, if I read it correctly, does not support files crossing 
> 32/64 bits boundaries (exec or SCM_RIGHTS).
>
>   

The compat code is not already finished, I plan to address compat
code on the next version.

> [timers]
> Returns a structure instead of a 32 bit counter (ala timerfd), and needs 
> extra compat code.
>   

Yes, but the compat code will be quite small.


> [signal]
> All the discussions that went on for signalfd has been lost. It pins the 
> task struct and it does not handle process detach signaling.
>   

No, I just went into a different direction.

> [aio]
> I prefer a signaling-only approach like the 20 lines patch I posted, and 
> use the standard AIO calls to fetch results. This code simply wraps AIO 
> calls. This is just my opinions of course, and others may disagree.
>   

The write()/read() wraps are just for the sake of completeness. The import
part is the poll().

> [futex]
> I intentionally stayed out of there after all the talks about futexfd 
> being killed due to the impossibility of getting an interface right (did 
> not follow the talk, so I can't tell the level of BS contained in the 
> previous statement). We also have a nice printk in there, with the first 
> kill-on deadline that ever made mainline :)
>
>   
Yes, i was more daring (or crazy). The plfutex is so simple, i don't
know why we can't get it right. It's just a _event_ (address/value).

--
Davi Arnaut
