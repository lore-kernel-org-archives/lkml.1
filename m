Return-Path: <linux-kernel-owner+w=401wt.eu-S1758875AbXHOHEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875AbXHOHEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 03:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbXHOHEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 03:04:12 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47834 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753716AbXHOHEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 03:04:10 -0400
Date: Wed, 15 Aug 2007 09:04:07 +0200
From: Sebastian Siewior <sebastian@breakpoint.cc>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] i386: use asm() like the other atomic operations
	already do.
Message-ID: <20070815070407.GA28936@Chamillionaire.breakpoint.cc>
References: <20070814223845.518697567@breakpoint.cc> <20070814224337.547449183@breakpoint.cc> <20070815002034.GW3406@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070815002034.GW3406@bingen.suse.de>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen | 2007-08-15 02:20:35 [+0200]:

>> My config with march=pentium-m and gcc (GCC) 4.1.2 (Gentoo 4.1.2):
>>   text    data     bss     dec     hex filename
>> 3434150  249176  176128 3859454  3ae3fe atomic_normal/vmlinux
>> 3435308  249176  176128 3860612  3ae884 atomic_inlineasm/vmlinux
>
>What is the difference between atomic_normal and atomic_inlineasm? 
atomic normal is Linus' tree, commit 28e8351. Inline asm is with this
patch. I wrote this in 0/2 (you want this here as well?).

>
>>  /**
>>   * atomic_read - read atomic variable
>>   * @v: pointer of type atomic_t
>> - * 
>> + *
>
>Please don't change white space in patches
I fixed white space errors. SubmitChecklist:24 says I should not
introduce any new ones so fixing existig sounds like the right thing to
do.
No white space fixing in future?

>
>>   * Atomically reads the value of @v.
>> - */ 
>> -#define atomic_read(v)		((v)->counter)
>> + */
>> +static __inline__ int atomic_read(const atomic_t *v)
>> +{
>> +	int t;
>> +
>> +	__asm__ __volatile__(
>
>And don't use __*__ in new code
Okey.

>
>-Andi

Sebastian
