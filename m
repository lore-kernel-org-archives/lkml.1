Return-Path: <linux-kernel-owner+w=401wt.eu-S1763059AbZD1RmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763059AbZD1RmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbZD1Rlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:41:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58234 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbZD1Rlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:41:50 -0400
Message-ID: <49F73F79.7060809@zytor.com>
Date: Tue, 28 Apr 2009 10:40:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86: cleanup alternative.h
References: <20090422201852.092307236@polymtl.ca> <20090422202453.673946867@polymtl.ca> <20090428130501.GC26600@Krystal> <20090428145839.GA26546@elte.hu>
In-Reply-To: <20090428145839.GA26546@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> Please try to align both the continuation backslashes and the 
> comments vertically. Something like:
> 
>> +#define ALTERNATIVE(oldinstr, newinstr, feature)			 \
>> +									 \
>> +	"661:\n\t" oldinstr "\n662:\n"					 \
>> +	".section .altinstructions,\"a\"\n"			 	 \
>> +	_ASM_ALIGN "\n"						 	 \
>> +	_ASM_PTR "661b\n"			   /* label           */ \
>> +	_ASM_PTR "663f\n"			   /* new instruction */ \
>> +	 "	 .byte " __stringify(feature) "\n" /* feature bit     */ \
>> +	 "	 .byte 662b-661b\n"		   /* sourcelen       */ \
>> +	 "	 .byte 664f-663f\n"		   /* replacementlen  */ \ 
> 
> ... should do the trick. (also note the extra line after the #define)
> 

This formatting seems a bit odd; _ASM_ALIGN, _ASM_PTR, and .section are
functionally equivalent to the opcode field, as is .byte, so the shift
in indentation for the .byte lines seems odd at best.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

