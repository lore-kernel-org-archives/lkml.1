Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbZCYMb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbZCYMb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758117AbZCYMbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:31:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:56590 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756936AbZCYMbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:31:14 -0400
Message-ID: <49CA2345.70204@kernel.org>
Date: Wed, 25 Mar 2009 21:27:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
References: <1236671631-9305-1-git-send-email-tj@kernel.org> <20090316190132.7965a49a@skybase> <49C300D8.5080204@kernel.org> <49C8FAC4.6060508@kernel.org> <20090325122738.42d105b7@skybase> <49CA1AC3.9080908@kernel.org> <20090325122241.GE11571@elte.hu>
In-Reply-To: <20090325122241.GE11571@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 12:27:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Tejun Heo <tj@kernel.org> wrote:
> 
>>> With your patches and a RELOC_HIDE version that uses the GOTENT 
>>> indirection the kernel won't compile because the "X" constraint 
>>> for the GOTENT access needs a symbol and there are quite a few 
>>> users that pass a pointer. I do not see a simple solution for 
>>> that problem yet.
>> Ah... okay.  Now I get it.  It wasn't expecting variables there.  How
>> about doing the following?
>>
>>  #define SHIFT_PERCPU_PTR(ptr, offset) (({				\
>> 	 if (__builtin_constant_p(ptr))					\
>> 		 do GOTENT trick;					\
>> 	 else								\
>> 		 RELOC_HIDE();						\
>>  }))
>>
>> Thanks.
> 
> Btw., is there any intermediate fix/workaround i could apply 
> perhaps? I'd like to send the percpu bits early in the merge window 
> and would hate to break Martin's arch ...

Martin's original patch should do the trick although it would be
slower for static symbols.  I'll merge it and post the tree.

BTW, I couldn't do the sparc32 test as the sparc I got is IIe which
can't boot 32 bit kernels.  :-(

Thanks.

-- 
tejun
