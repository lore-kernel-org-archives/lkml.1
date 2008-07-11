Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbYGKLOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbYGKLOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbYGKLNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:13:50 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:29772 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbYGKLNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:13:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tcEI/YiA0Kt4HOBRRM5gQvyg5P+An+lvCgtp9M0imnZnNiFuJIoQUMI0RGkliNQc43
         mumU2tkNlb/6JYx5XAkP6NeWw5siRHlYt/VoozqQzO5unVm/q17YcwMgXxzRVieBFvn8
         ifp+v8Ak44zphi5VJ79Q526277nvEeBW477r4=
Message-ID: <48774065.4070300@gmail.com>
Date: Fri, 11 Jul 2008 14:13:41 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Elias Oltmanns <eo@nebensachen.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: fix delayed signals
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu>
In-Reply-To: <20080711054605.GA17851@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-07-11 08:46, Ingo Molnar wrote:
> * Roland McGrath <roland@redhat.com> wrote:
>
>   
>> On three of the several paths in entry_64.S that call 
>> do_notify_resume() on the way back to user mode, we fail to properly 
>> check again for newly-arrived work that requires another call to 
>> do_notify_resume() before going to user mode.  These paths set the 
>> mask to check only _TIF_NEED_RESCHED, but this is wrong.  The other 
>> paths that lead to do_notify_resume() do this correctly already, and 
>> entry_32.S does it correctly in all cases.
>>     
>
> nice find! Roland, is this related to the thread started by Elias 
> Oltmanns yesterday:
>
>     http://lkml.org/lkml/2008/7/10/57
>   

I will try to get a latency trace using the debug features in
linux-next, but first
I have to bisect a boot failure in linux-next.

> which is also related to the thread started by Edwin Török:
>
>     http://lkml.org/lkml/2008/6/28/50
>
> ? The weight of complains seems to be on the 64-bit side, in those 
> threads 32-bit systems seem to be implicated as well by latencytop. 
> Perhaps the 64-bit delays are related to the bug you fix and we could 
> chalk up the 32-bit delays to IO delays?
>
> more people Cc:-ed: if your delays happen on 64-bit x86 systems - does 
> Roland's patch (also repeated below) fix those delay issues?
>
>   

Thanks for CC-ing me.
I will give the patch a try.

Best regards,
--Edwin

