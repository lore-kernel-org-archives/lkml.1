Return-Path: <linux-kernel-owner+w=401wt.eu-S1760579AbXH2TNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579AbXH2TNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 15:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbXH2TN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 15:13:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119AbXH2TNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 15:13:25 -0400
Message-ID: <46D5C552.1060307@redhat.com>
Date: Wed, 29 Aug 2007 15:13:22 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Clark Cooper <clark.cooper@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Caught SIGFPE exceptions aren't reset
References: <e21d91280708242140i2e6223a4v51ba016837b74be8@mail.gmail.com>	 <18128.322.59087.367556@alkaid.it.uu.se>	 <e21d91280708251018l4904b6bcm5b40e22b6b2cbedc@mail.gmail.com> <e21d91280708251031k5e3bd962o6a268e6506696a8c@mail.gmail.com>
In-Reply-To: <e21d91280708251031k5e3bd962o6a268e6506696a8c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2007 01:31 PM, Clark Cooper wrote:
>> Your handler can do this by masking
>>  exceptions, changing the operands of the failed FP instruction,
>> or by changing the PC so that the failed instruction is skipped
>> (your handler may want to emulate the instruction in this case).
> 
> Given the current SIGFPE handling in the kernel, a userland handler
> CAN'T mask the exceptions or clear the exception flags. This is
> demonstrated in my example program where I call both feclearexception
> and fedisableexception in the handler. The reason these don't work is
> that any change you make to these FPU registers is overwritten with
> the saved FPU context on return from the signal handler. Changing the
> PC won't help since the exception flag is still set and unmasked on
> signal return.

Just change the saved FPU context before returning. (It's on the stack
when your handler is running.)
