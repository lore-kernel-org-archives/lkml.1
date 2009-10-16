Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbZJPILT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbZJPILT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 04:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757345AbZJPILP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 04:11:15 -0400
Received: from smail2.alcatel.fr ([64.208.49.57]:34643 "EHLO smail2.alcatel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757241AbZJPILN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 04:11:13 -0400
Message-ID: <4AD82A4A.9060006@alcatel-lucent.de>
Date: Fri, 16 Oct 2009 10:09:46 +0200
From: Joerg Abraham <Joerg.Abraham@alcatel-lucent.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: John Kacur <jkacur@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.31.4-rt14 posix message queues problem (solved)
References: <4AD76126.1000408@alcatel-lucent.de> <520f0cf10910151202k2ba01453r10e96eeb064232e8@mail.gmail.com> <alpine.LFD.2.00.0910152105430.8932@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0910152105430.8932@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

> Hello Joerg
> 
> Does the following patch solve your problem? 

yes, (verified on powerpc and x86_64)

so it may be save to include your patch into the next rt release.

Thanx,

Joerg


> 
> From 69fde4357db4a054733cbca4158606160e821a3a Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Thu, 15 Oct 2009 20:52:37 +0200
> Subject: [PATCH] preempt_disable_rt(); should be paired with preempt_enable_rt()
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  ipc/mqueue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 63a47f7..ab4df36 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -830,7 +830,7 @@ static inline void pipelined_send(struct mqueue_inode_info *info,
>  	wake_up_process(receiver->task);
>  	smp_wmb();
>  	receiver->state = STATE_READY;
> -	preempt_enable_nort();
> +	preempt_enable_rt();
>  }
>  
>  /* pipelined_receive() - if there is task waiting in sys_mq_timedsend()

