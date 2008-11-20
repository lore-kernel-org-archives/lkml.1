Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbYKTAHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbYKTAHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 19:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYKTAHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 19:07:45 -0500
Received: from gw.goop.org ([64.81.55.164]:51210 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbYKTAHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 19:07:44 -0500
Message-ID: <4924AA4E.4090001@goop.org>
Date: Wed, 19 Nov 2008 16:07:42 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Eric Lacombe <goretux@gmail.com>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [x86] do_arch_prctl
References: <200811181835.07360.goretux@gmail.com> <200811191023.16358.goretux@gmail.com> <49247FC6.8080201@goop.org> <200811200035.57509.goretux@gmail.com>
In-Reply-To: <200811200035.57509.goretux@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Lacombe wrote:
> Thanks for your answer, I've got one last question ;)
> In the ARCH_GET_GS, can you explain the line 834 to 838?
>
> In fact, at first sight I thought that just the line 836 was sufficient, but I 
> obviously miss the case where MSR_KERNEL_GS_BASE does not reflect the value 
> requested, hence my question.
>   

I think the rationale is that rdmsr is slow, so reading the value from 
the task context is faster where possible.

It's not a very pretty part of the architecture :/

    J

> 828 case ARCH_GET_GS: {
> 829                 unsigned long base;
> 830                 unsigned gsindex;
> 831                 if (task->thread.gsindex == GS_TLS_SEL)
> 832                         base = read_32bit_tls(task, GS_TLS);
> 833                 else if (doit) {
> 834                         asm("movl %%gs,%0" : "=r" (gsindex));
> 835                         if (gsindex)
> 836                                 rdmsrl(MSR_KERNEL_GS_BASE, base);
> 837                         else
> 838                                 base = task->thread.gs;
> 839                 }
> 840                 else
> 841                         base = task->thread.gs;
>
> Thanks,
>
> 	Eric
>
>
>   

