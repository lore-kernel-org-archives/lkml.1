Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab0BBIa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 03:30:58 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:21879 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0BBIa5 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Tue, 2 Feb 2010 03:30:57 -0500
Message-Id: <4B67F0CC020000780002D200@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 02 Feb 2010 08:30:52 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: enlightenment for ticket spinlocks -
	 remove  NOPs from unlock path
References: <4B62A40B020000780002CA99@vpn.id2.novell.com>
 <4B675BBB.20303@zytor.com>
In-Reply-To: <4B675BBB.20303@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "H. Peter Anvin" <hpa@zytor.com> 01.02.10 23:54 >>>
>> --- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/include/asm/alternative-asm.h
>> +++ 2.6.33-rc5-virt-spinlocks/arch/x86/include/asm/alternative-asm.h
>> @@ -1,3 +1,7 @@
>> +#if 0 /* Hide this from compiler. */
>> +	.if 0 # Hide assembly source stuff when assembling compiler output.
>> +#endif
>> +
>>  #ifdef __ASSEMBLY__
>>  
>>  #include <asm/asm.h>
>> @@ -16,3 +20,58 @@
>>  #endif
>>  
>>  #endif  /*  __ASSEMBLY__  */
>> +
>> +#if 0 /* Hide this from compiler. */
>> +	.else # Code to be used in compiler output:
>> +
>> +	.weak _$.zero
>> +
>> +	.macro unary opc arg1 arg2 arg3
>...
>> +	.endm
>> +
>> +	.endif
>> +#endif
>
>Okay, I have absolutely no idea what this macro either *does* or what
>it's *supposed to do* nor if it matches... you kind of forgot to
>describe that.

It does what the patch description says - extend the (memory) operand
of a unary opcode (inc in the case where it's being used) to maximum
width (i.e. to include a 32-bit displacement regardless of whether one
really is needed). It just needs to consider the different cases of what
operands gcc may output. And it gets more complicated because
commas in the operand are being treated as macro operand separators.

>The other bit is that this whole handling with .if and
>#if is just too ugly to live.  Create two include files at the very minimum.

The new one ought to use the same construct then anyway, as inclusion
of the file visible to gcc is desirable for dependency tracking, while
wrapping the whole construct in an __asm__() doesn't seem desirable
to me due to it making the whole thing even less readable.

Jan

