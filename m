Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbZCLLfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbZCLLfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbZCLLfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:35:24 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:34821 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZCLLfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:35:23 -0400
Message-Id: <49B901B1.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 11:36:01 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Alexander van Heukelum" <heukelum@fastmail.fm>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Cyrill Gorcunov" <gorcunov@gmail.com>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: add unwind annotations to
	 early_idt_handler
References: <49B8F3A2.76E4.0078.0@novell.com>
 <20090312105345.GB30204@elte.hu>
In-Reply-To: <20090312105345.GB30204@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 12.03.09 11:53 >>>
>* Jan Beulich <jbeulich@novell.com> wrote:
>> @@ -295,6 +297,16 @@ ENTRY(early_idt_handler)
>>  	testl $0x27d00,%eax
>>  	je 0f
>>  	popq %r8		# get error code
>> +
>> +	CFI_STARTPROC	simple
>> +	CFI_SIGNAL_FRAME
>> +	CFI_DEF_CFA	rsp, SS+8-RIP
>> +#	CFI_REL_OFFSET	ss, SS-RIP
>> +	CFI_REL_OFFSET	rsp, RSP-RIP
>> +#	CFI_REL_OFFSET	rflags, EFLAGS-RIP
>> +#	CFI_REL_OFFSET	cs, CS-RIP
>> +	CFI_REL_OFFSET	rip, RIP-RIP
>> +
>
>This too is too ugly - there should be a structured macro that 
>expresses this - instead of open-coded CFI details. This is a 
>regular x86 entry layout with a lot of commonalities with other 
>entry points.

I can certainly do that, but it'll introduce yet another patch
dependency (with the patch fixing the entry_64.S annotations), as it
would mean moving out some of the macros from entry_64.S to one
of the headers. That means I'll first have to get clarification on where
you want to go with these annotations altogether.

Jan

