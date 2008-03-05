Return-Path: <linux-kernel-owner+w=401wt.eu-S1760969AbYCEQHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760969AbYCEQHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760483AbYCEQGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:06:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43764 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760439AbYCEQGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:06:34 -0500
Message-ID: <47CEC408.2070604@zytor.com>
Date: Wed, 05 Mar 2008 08:02:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephan Diestelhorst <langer_mann@web.de>, davej@codemonkey.org.uk,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Speedfreq-SMI call clobbers ECX
References: <200803051559.09962.langer_mann@web.de> <20080305153520.GB19300@elte.hu>
In-Reply-To: <20080305153520.GB19300@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Stephan Diestelhorst <langer_mann@web.de> wrote:
> 
>> @@ -184,7 +184,7 @@ static void speedstep_set_state (unsigne
>>  		__asm__ __volatile__(
>>  			"movl $0, %%edi\n"
>>  			"out %%al, (%%dx)\n"
>> -			: "=b" (new_state), "=D" (result)
>> +			: "=b" (new_state), "=D" (result), "=c" (ecx_clobber)
>>  			: "a" (command), "b" (function), "c" (state), "d" (smi_port), "S" (0)
>>  			);
> 
> stupid suggestion: why not do a pusha/popa around those instructions, to 
> make sure everything is restored? This isnt a fastpath and being 
> conservative about SMI side-effects cannot hurt ...
> 

You can't pusha/popa if you expect a result.  You can, of course, push 
and pop individual registers.

It's also kind of odd to do "movl $0,%%edi" instead of just setting EDI 
as an input.

	-hpa
