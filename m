Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbZKDNWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbZKDNWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbZKDNWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:22:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756025AbZKDNWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:22:15 -0500
Message-ID: <4AF17F04.1030709@redhat.com>
Date: Wed, 04 Nov 2009 08:17:56 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH]: use spin_lock_irqsave in try_one_irq()
References: <20091103134342.24414.82986.sendpatchset@prarit.bos.redhat.com>	 <2674af740911030658m76b702cfxb67723984286c4bb@mail.gmail.com>	 <alpine.LFD.2.00.0911041016070.12138@localhost.localdomain>	 <2674af740911040449h14eaac35y2ec3016862479bc6@mail.gmail.com> <2674af740911040501p4ef8b6c5jcbd11f1a57dbf8b7@mail.gmail.com>
In-Reply-To: <2674af740911040501p4ef8b6c5jcbd11f1a57dbf8b7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yong Zhang wrote:
> From 83ee4c7591aae764f1656bd68f6e95ae112e2e7a Mon Sep 17 00:00:00 2001
> From: Yong Zhang <yong.zhang0@gmail.com>
> Date: Wed, 4 Nov 2009 20:52:45 +0800
> Subject: [PATCH] genirq: try_one_irq() should be called with irq disabled
>
> Prarit report this:
>   

<snip>

Testing verifies that this patch works.

P.

> Reported-by: Prarit Bhargava <prarit@redhat.com>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---
>  kernel/irq/spurious.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
> index 114e704..bd7273e 100644
> --- a/kernel/irq/spurious.c
> +++ b/kernel/irq/spurious.c
> @@ -121,7 +121,9 @@ static void poll_all_shared_irqs(void)
>  		if (!(status & IRQ_SPURIOUS_DISABLED))
>  			continue;
>
> +		local_irq_disable();
>  		try_one_irq(i, desc);
> +		local_irq_enable();
>  	}
>  }
>
>   
