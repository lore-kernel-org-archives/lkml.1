Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbYKMRyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbYKMRyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYKMRxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:53:55 -0500
Received: from rn-out-0910.google.com ([64.233.170.184]:46934 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYKMRxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:53:55 -0500
Message-ID: <491C69B5.100@colorfullife.com>
Date: Thu, 13 Nov 2008 18:53:57 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nadia Derbey <Nadia.Derbey@bull.net>
CC: Andrew Morton <akpm@linux-foundation.org>, cboulte@gmail.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] SYSVIPC - Fix the ipc structures initialization
References: <20081028145952.620752409@bull.net> <20081028150041.857635775@bull.net> <4f3ee3290810290211y75a2d0eaoe666496e25496260@mail.gmail.com> <20081111141603.f0e7fa8d.akpm@linux-foundation.org> <491BC4B8.1050406@colorfullife.com> <1226570880.2585.41.camel@frecb000730.frec.bull.fr>
In-Reply-To: <1226570880.2585.41.camel@frecb000730.frec.bull.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nadia Derbey wrote:
> That's what the patch I sent at the beginning of this thread
> (http://lkml.org/lkml/2008/10/28/177) fixes: the ipc structure is not
> completely initialized before being inserted in the tree.
>
> The patched kernel has been running for 4 days on my victim without any
> problem, but Clement is still facing a problem (that comes later).
>
> I think this patch should be included anyways, because ipc structures
> initialization is not correct the way it is done today.
>
>   
Definitively: Your patch belongs into 2.6.28 and the next 2.6.27.

> I'm still reviewing the code to see what else could be wrong.
>   
I started looking into the idr code: perhaps idr returns a stale entry? 
A race somewhere in the RCU code.
I.e. the new bug is not corruption due to access before 
spin_lock_init(), but due to access after kfree()?

Clement: Could you send us an ipcs output from before the test?
Do you have any sysv msg queues on your system?
And: Do you use PREEMPT, do you use PREEMPT_RCU?

If there are no message queues around, then every msgget()/IPC_RMID will 
create a new idr layer/tear the layer down again.

--
    Manfred
