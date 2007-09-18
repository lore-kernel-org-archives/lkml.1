Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbXIRWR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbXIRWR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbXIRWRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:17:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37835 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695AbXIRWRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:17:08 -0400
Message-ID: <46F04D53.6040903@zytor.com>
Date: Tue, 18 Sep 2007 15:12:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org>
In-Reply-To: <46F04856.3010808@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Mathieu Desnoyers wrote:
> 
>> +#define immediate_read(name)						\
>> +	({								\
>> +		__typeof__(name##__immediate) value;			\
>> +		switch (sizeof(value)) {				\
>> +		case 1:							\
>> +			asm (	".section __immediate, \"a\", @progbits;\n\t" \
>> +					".long %1, (0f)+1, 1;\n\t"	\
>> +					".previous;\n\t"		\
>> +					"0:\n\t"			\
>> +					"mov %2,%0;\n\t"		\
> 
> Given that you're relying on the exact instruction that this mov
> generates, it might be better to explicitly put the opcodes in with
> .byte.  That way you're protected from the assembler deciding to
> generate some other form of the instruction (for whatever reason).  I
> guess substituting in different registers would be a pain.

Allowing different registers should be doable, but if so, one would have
to put 0: at the *end* of the instruction and use (0f)-4 instead, since
the non-%eax forms are one byte longer.

This also seems "safer", since an imm32 is always the last thing in the
instruction.

	-hpa

