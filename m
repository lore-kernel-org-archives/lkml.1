Return-Path: <linux-kernel-owner+w=401wt.eu-S1763600AbXHFKnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763600AbXHFKnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbXHFKm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:42:56 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:34109
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688AbXHFKm4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:42:56 -0400
Message-Id: <46B71781.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 06 Aug 2007 11:43:45 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeff Garzik" <jeff@garzik.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [PATCH] [34/58] x86_64: ia32entry adjustments
References: <200707191154.642492000@suse.de>
 <20070719095520.2124414E06@wotan.suse.de> <469F7962.6020108@garzik.org>
In-Reply-To: <469F7962.6020108@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeff Garzik <jeff@garzik.org> 19.07.07 16:46 >>>
>Andi Kleen wrote:
>> From: "Jan Beulich" <jbeulich@novell.com>
>> Consolidate the three 32-bit system call entry points so that they all
>> treat registers in similar ways.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>> Signed-off-by: Andi Kleen <ak@suse.de>
>> 
>>  arch/x86_64/ia32/ia32entry.S |    5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>> 
>> Index: linux/arch/x86_64/ia32/ia32entry.S
>> ===================================================================
>> --- linux.orig/arch/x86_64/ia32/ia32entry.S
>> +++ linux/arch/x86_64/ia32/ia32entry.S
>> @@ -104,7 +104,7 @@ ENTRY(ia32_sysenter_target)
>>  	pushq	%rax
>>  	CFI_ADJUST_CFA_OFFSET 8
>>  	cld
>> -	SAVE_ARGS 0,0,0
>> +	SAVE_ARGS 0,0,1
>>   	/* no need to do an access_ok check here because rbp has been
>>   	   32bit zero extended */ 
>>  1:	movl	(%rbp),%r9d
>> @@ -294,7 +294,7 @@ ia32_badarg:
>>   */ 				
>>  
>>  ENTRY(ia32_syscall)
>> -	CFI_STARTPROC	simple
>> +	CFI_STARTPROC32	simple
>>  	CFI_SIGNAL_FRAME
>>  	CFI_DEF_CFA	rsp,SS+8-RIP
>>  	/*CFI_REL_OFFSET	ss,SS-RIP*/
>> @@ -330,6 +330,7 @@ ia32_sysret:
>>  
>>  ia32_tracesys:			 
>>  	SAVE_REST
>> +	CLEAR_RREGS
>>  	movq $-ENOSYS,RAX(%rsp)	/* really needed? */
>>  	movq %rsp,%rdi        /* &pt_regs -> arg1 */
>>  	call syscall_trace_enter
>
>More comments and/or a less vague patch description would be nice.
>
>What registers?  What behavior is being made common?  Why?

I think the description says this quite well - which registers are being saved/
cleared is being made consistent (not common).

Jan

