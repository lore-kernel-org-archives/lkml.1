Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbYBSX1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbYBSX1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYBSX1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:27:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54240 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbYBSX1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:27:07 -0500
Message-ID: <47BB6558.4020201@zytor.com>
Date: Tue, 19 Feb 2008 15:25:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>, Shi Weihua <shiwh@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow
 check
References: <47B95C4D.6080000@cn.fujitsu.com>	<47BA3CAB.30905@cn.fujitsu.com>	<20080219110536.GA2683@elte.hu> <18363.25743.402510.695150@cargo.ozlabs.ibm.com>
In-Reply-To: <18363.25743.402510.695150@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Ingo Molnar writes:
>> * Shi Weihua <shiwh@cn.fujitsu.com> wrote:
>>
>>> We need to check for stack overflow only when the signal is on stack. 
>>> So we can improve the patch "http://lkml.org/lkml/2007/11/27/101" as 
>>> following.
>> thanks, applied.
> 
> These patches change the behaviour of programs that longjmp out of a
> signal handler on an alternate stack, don't they?
> 
> I'm interested to know what gave you confidence that changing that
> behaviour won't break existing working programs.
> 

Shouldn't such programs use sigsetjmp/siglongjmp, which should reset the 
signal stack state?

	-hpa
