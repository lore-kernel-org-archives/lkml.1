Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279Ab0AaUvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0AaUvM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 15:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115Ab0AaUvL
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 15:51:11 -0500
Received: from mail-iw0-f173.google.com ([209.85.223.173]:38646 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab0AaUvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 15:51:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ys7D+iiHHj8LRMsdWJx0qkga7c+IG8/hZK2emu6T57Kk4iH5J3W+REvxIk/DPWJxMM
         QCQC7fpqxz0bPzXki54/+SIll9tE+KRzYwMBTWzj2ohihboxctXyVkycrPaKEQE8QnJk
         vkxfAk51aqbLnYblgEd3cx0BLWkLVaU1s1doc=
Date: Sun, 31 Jan 2010 14:50:43 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: High scheduler wake up times
Message-ID: <20100131205043.GF27390@mediacenter.gateway.2wire.net>
References: <20100130234551.GA27390@mediacenter.gateway.2wire.net> <20100130161114.07278221@infradead.org> <20100131003549.GC27390@mediacenter.gateway.2wire.net> <20100130164716.230dfe31@infradead.org> <20100131034718.GE27390@mediacenter.gateway.2wire.net> <20100131102846.4d1e18aa@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100131102846.4d1e18aa@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 10:28:46AM -0800, Arjan van de Ven wrote:
> can you run powertop during your workload? maybe you're getting hit by
> some C state exit latencies tilting the rounding over the top just too
> many times...

Running 50 of the example processes and powertop on 2.6.32.7, with the
performance cpu governor:

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        (24.7%)
polling           0.0ms ( 0.0%)
C1 mwait          0.3ms ( 0.0%)
C3 mwait          0.8ms (75.3%)


Wakeups-from-idle per second : 980.1    interval: 10.0s
no ACPI power usage estimate available

Top causes for wakeups:
  76.2% (45066.9)    worker_process : sys_epoll_wait (process_timeout) 
  22.0% (13039.2)     <kernel core> : hrtimer_start_range_ns (tick_sched_timer) 
   1.5% (892.7)            kipmi0 : schedule_timeout_interruptible (process_timeout) 
   0.2% (105.0)     <kernel core> : add_timer (smi_timeout) 
   0.0% ( 10.5)       <interrupt> : ata_piix 
   0.0% ( 10.1)     <kernel core> : ipmi_timeout (ipmi_timeout) 


I also tried booting with processor.max_cstate=0 which causes powertop
to no longer show any cstate information but I assumed that would keep
me fixed at C0.  Booting with processor.max_cstate=0 didn't seem to make
any difference.

Thanks,
Shawn
