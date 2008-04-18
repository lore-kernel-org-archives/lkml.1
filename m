Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbYDRKE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbYDRKE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 06:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbYDRKEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 06:04:16 -0400
Received: from gw.goop.org ([64.81.55.164]:58196 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbYDRKEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 06:04:16 -0400
Message-ID: <48087217.50305@goop.org>
Date: Fri, 18 Apr 2008 20:04:07 +1000
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080407)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, akpm@osdl.org,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v4)
References: <20080417164116.GB23351@Krystal>
In-Reply-To: <20080417164116.GB23351@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> +/*
> + * Only returns from a trap or exception to a NMI context (intra-privilege
> + * level near return) to the same SS and CS segments. Should be used
> + * upon trap or exception return when nested over a NMI context so no iret is
> + * issued. It takes care of modifying the eflags, rsp and returning to the
> + * previous function.
> + *
> + * The stack, at that point, looks like :
> + *
> + * 0(rsp)  RIP
> + * 8(rsp)  CS
> + * 16(rsp) EFLAGS
> + * 24(rsp) RSP
> + * 32(rsp) SS
> + *
> + * Upon execution :
> + * Copy EIP to the top of the return stack
> + * Update top of return stack address
> + * Pop eflags into the eflags register
> + * Make the return stack current
> + * Near return (popping the return address from the return stack)
> + */
> +#define INTERRUPT_RETURN_NMI_SAFE	pushq %rax;		\
> +					mov %rsp, %rax;		\
> +					mov 24+8(%rax), %rsp;	\
> +					pushq 0+8(%rax);	\
> +					pushq 16+8(%rax);	\
> +					movq (%rax), %rax;	\
> +					popfq;			\
> +					ret;
>   

I got this right first go?  I must be getting good at this...

Anyway, trailing ';', and perhaps use a consistent form for mov (either 
movq or mov in all three instances).

    J
