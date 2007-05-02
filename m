Return-Path: <linux-kernel-owner+w=401wt.eu-S1766786AbXEBTms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766786AbXEBTms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766794AbXEBTms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:42:48 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1625 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766786AbXEBTmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:42:47 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 2 May 2007 12:42:45 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Davi Arnaut <davi@haxent.com.br>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 00/22] pollfs: filesystem abstraction for pollable objects
In-Reply-To: <4638DD76.7090904@haxent.com.br>
Message-ID: <Pine.LNX.4.64.0705021159340.7176@alien.or.mcafeemobile.com>
References: <20070502052235.914764000@haxent.com.br>
 <20070501230529.424f17c6.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705021010390.7176@alien.or.mcafeemobile.com>
 <4638CECE.6060409@haxent.com.br> <Pine.LNX.4.64.0705021053040.7176@alien.or.mcafeemobile.com>
 <4638DD76.7090904@haxent.com.br>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Davi Arnaut wrote:

> So in this case I may borrow some signalfd code :-) I really like the
> signalfd approach, but IMHO the code is quite ugly and duplicates
> a lot of hairy code.

Ugly, really? Please ...

+	while (!mutex_trylock(&evs->mutex))
+		cpu_relax();

So, let's see. The whole things adds an unneeded (read "empty") extra 
layer of indirections over the existing file_operations. Timerfd added the 
return of the structure (because "developer may need it"), that wants 
extra compat too. Your signal code does not handle things that is supposed 
to be handling (easy to write clean code when the code does not actually 
do what is supposed to be doing), and you'll be sucking code from 
signalfd. On top of that, it returns a structure that needs compat too. 
AIO code added an extra unnecessary wrapper over AIO native calls (by 
literally calling sys_io_*). And the compat on sys_read/sys_write I 
guess will be funny to watch. So what does your code effectively adds that 
is useful in some way? Undocumented and testcase-less code?
As I see it, your code badly copies exiting one, and adds uneeded 
infrastrcture/functionality.
See, I really wouldn't care, if you'd keep the "ugly" word for yourself.
Actually, I really care only about the functionality, so I leave the whole 
ball into Andrew's hands ;)



- Davide


