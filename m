Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbYAQDRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbYAQDRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 22:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYAQDRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 22:17:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58631 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYAQDRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 22:17:34 -0500
Message-ID: <478EC77E.8090103@zytor.com>
Date: Wed, 16 Jan 2008 22:11:58 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andi Kleen <ak@suse.de>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/7] Use shorter addresses in i386 segfault printks
References: <200801161127.268350000@suse.de>	 <20080116222706.8074A14EE3@wotan.suse.de> <1200538738.17967.4.camel@brick>
In-Reply-To: <1200538738.17967.4.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> On Wed, 2008-01-16 at 23:27 +0100, Andi Kleen wrote:
>> Signed-off-by: Andi Kleen <ak@suse.de>
>>
>> ---
>>  arch/x86/mm/fault_32.c |    2 +-
> 
> Could use exactly the same in fault_64.c
> 
>>  #ifdef CONFIG_X86_32
>> -			"%s%s[%d]: segfault at %08lx ip %08lx sp %08lx error %lx\n",
>> +			"%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx\n",
>>  #else
>>  			"%s%s[%d]: segfault at %lx ip %lx sp %lx error %lx\n",
>>  #endif
> 
> With the ongoing unification work, it would be nice if we could come
> up with a way to unify printks like this.  Anyone have any bright ideas
> on a format that will keep the current alignment on 32 and 64 bit with
> the same syntax, or will these tiny ifdefs keep sprouting?
> 

Casting to (void *) and using %p is probably your best bet.  That's what 
it really is anyway.

Note: in the kernel right now, %p doesn't have the leading 0x prefix, 
which it probably should...

	-hpa
