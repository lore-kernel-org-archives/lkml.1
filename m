Return-Path: <linux-kernel-owner+w=401wt.eu-S1761907AbZCYOR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761907AbZCYOR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZCYORS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:17:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:57670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbZCYORR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:17:17 -0400
Message-ID: <49CA3C2C.5030702@kernel.org>
Date: Wed, 25 Mar 2009 23:14:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
References: <1236671631-9305-1-git-send-email-tj@kernel.org>	<20090316190132.7965a49a@skybase>	<49C300D8.5080204@kernel.org>	<49C8FAC4.6060508@kernel.org>	<20090325122738.42d105b7@skybase>	<49CA1AC3.9080908@kernel.org> <20090325150035.541e707a@skybase>
In-Reply-To: <20090325150035.541e707a@skybase>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 14:14:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> On Wed, 25 Mar 2009 20:51:31 +0900
> Tejun Heo <tj@kernel.org> wrote:
> 
>>> With your patches and a RELOC_HIDE version that uses the GOTENT
>>> indirection the kernel won't compile because the "X" constraint for
>>> the GOTENT access needs a symbol and there are quite a few users that
>>> pass a pointer. I do not see a simple solution for that problem yet.
>> Ah... okay.  Now I get it.  It wasn't expecting variables there.  How
>> about doing the following?
>>
>>  #define SHIFT_PERCPU_PTR(ptr, offset) (({				\
>> 	 if (__builtin_constant_p(ptr))					\
>> 		 do GOTENT trick;					\
>> 	 else								\
>> 		 RELOC_HIDE();						\
>>  }))
> 
> That doesn't work because __builtin_constant_p is false for variable
> symbols. I would need a __builtin_symbol_p but that doesn't exist.

Right, I somehow always get confused about the two.  Eh... Not easy.
I think alpha might have the same problem too.  I suppose we'll have
to make the legacy allocator available for alpha and s390 for the time
being.  I'll get to that.

Thanks.

-- 
tejun
