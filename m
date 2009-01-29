Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbZA2Jax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbZA2Jax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 04:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbZA2Jah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 04:30:37 -0500
Received: from gw.goop.org ([64.81.55.164]:51175 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbZA2Jag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 04:30:36 -0500
Message-ID: <4981773A.1050403@goop.org>
Date: Thu, 29 Jan 2009 01:30:34 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Subject: Re: [PATCH 4 of 7] x86/paravirt: selectively save/restore regs around
 pvops calls
References: <patchbomb.1233182100@abulafia.goop.org> <5849eb6475c1bbe5a6ca.1233182104@abulafia.goop.org> <200901291917.26601.rusty@rustcorp.com.au>
In-Reply-To: <200901291917.26601.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 29 January 2009 09:05:04 Jeremy Fitzhardinge wrote:
>   
>> +#define PV_SAVE_REGS(set)			\
>> +	COND_PUSH(set, CLBR_RAX, rax);		\
>> +	COND_PUSH(set, CLBR_RCX, rcx);		\
>> +	COND_PUSH(set, CLBR_RDX, rdx);		\
>> +	COND_PUSH(set, CLBR_RSI, rsi);		\
>> +	COND_PUSH(set, CLBR_RDI, rdi);		\
>> +	COND_PUSH(set, CLBR_R8, r8);		\
>> +	COND_PUSH(set, CLBR_R9, r9);		\
>> +	COND_PUSH(set, CLBR_R10, r10);		\
>> +	COND_PUSH(set, CLBR_R11, r11)
>>     
>
> It's kind of messy.  Can we do something clever here with token pasting?
>   

I tried a few things, but no.  Passing in just RAX, and then pasting 
CLBR_##reg works, and the assembler accepts %RAX - but - the asm code 
also #defines RAX <some stack offset>, so the assembler ends up seeing 
%48.  I considered renaming all the CLBR_ defines to CLBR_rax, but that 
looks unhappy too.  So I stayed with this.

    J
