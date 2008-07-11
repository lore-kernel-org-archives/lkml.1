Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbYGKMZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbYGKMZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbYGKMZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:25:10 -0400
Received: from nebensachen.de ([195.34.83.29]:49891 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbYGKMZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:25:09 -0400
X-Hashcash: 1:20:080711:mingo@elte.hu::LBcRbinOUzAb8Yd5:00000Uzr
X-Hashcash: 1:20:080711:roland@redhat.com::FrT/OANnqcYOFPQg:0000000000000000000000000000000000000000000039gB
X-Hashcash: 1:20:080711:tglx@linutronix.de::qt6XLlEm23dhtLlb:000000000000000000000000000000000000000000023z/
X-Hashcash: 1:20:080711:akpm@linux-foundation.org::qEXnBXR4Xk402x53:0000000000000000000000000000000000001F2x
X-Hashcash: 1:20:080711:torvalds@linux-foundation.org::CKbTwB8nhocCx+dd:000000000000000000000000000000006ojB
X-Hashcash: 1:20:080711:linux-kernel@vger.kernel.org::2i8Mqjclewm1pHya:00000000000000000000000000000000026F4
X-Hashcash: 1:20:080711:edwintorok@gmail.com::ChDdrrGkP+KkHKoh:000000000000000000000000000000000000000004Ygb
X-Hashcash: 1:20:080711:arjan@infradead.org::Ep1ULpSBAudIf3fA:0000000000000000000000000000000000000000008r5b
From: Elias Oltmanns <eo@nebensachen.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: fix delayed signals
References: <20080710215039.2A143154218@magilla.localdomain>
	<20080711054605.GA17851@elte.hu>
Date: Fri, 11 Jul 2008 14:24:31 +0200
In-Reply-To: <20080711054605.GA17851@elte.hu> (Ingo Molnar's message of "Fri,
	11 Jul 2008 07:46:05 +0200")
Message-ID: <87lk088v7k.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:
> * Roland McGrath <roland@redhat.com> wrote:
>
>> On three of the several paths in entry_64.S that call 
>> do_notify_resume() on the way back to user mode, we fail to properly 
>> check again for newly-arrived work that requires another call to 
>> do_notify_resume() before going to user mode.  These paths set the 
>> mask to check only _TIF_NEED_RESCHED, but this is wrong.  The other 
>> paths that lead to do_notify_resume() do this correctly already, and 
>> entry_32.S does it correctly in all cases.
>
> nice find! Roland, is this related to the thread started by Elias 
> Oltmanns yesterday:
>
>     http://lkml.org/lkml/2008/7/10/57
>
> which is also related to the thread started by Edwin Török:
>
>     http://lkml.org/lkml/2008/6/28/50
>
> ? The weight of complains seems to be on the 64-bit side, in those 
> threads 32-bit systems seem to be implicated as well by latencytop. 
> Perhaps the 64-bit delays are related to the bug you fix and we could 
> chalk up the 32-bit delays to IO delays?

Since I'm using a 32-bit machine, this patch isn't going to solve my
particular problem. Still, I'm glad to hear that someone is looking at
the assembly bits related to signal handling right now because that's
precisely the part where I gave up to figure out for myself how signal
handling works in the kernel.

As for delayed signal handling on 32-bit platforms due to heavy disk
I/O, I'm still reluctant to accept that signals should be delayed that
much even though everything else that is not related to disk I/O works
perfectly well. Now that I've seen some documentation for ftrace, I'll
give it a go and try produce some helpful data. However, I'm rather busy
right now and may not be able to do so before next week.

Regards,

Elias
