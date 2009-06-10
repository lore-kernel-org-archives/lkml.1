Return-Path: <linux-kernel-owner+w=401wt.eu-S1760896AbZFJTlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896AbZFJTlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbZFJTlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:41:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60670 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbZFJTlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:41:10 -0400
Message-ID: <4A2FFBDB.7070504@zytor.com>
Date: Wed, 10 Jun 2009 11:30:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: tj@kernel.org, JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       monstr@monstr.eu, ralf@linux-mips.org, kyle@mcmartin.ca,
       benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, lethal@linux-sh.org, jdike@addtoit.com,
       chris@zankel.net, rusty@rustcorp.com.au, jens.axboe@oracle.com,
       davej@redhat.com, jeremy@xensource.com, linux-mm@kvack.org
Subject: Re: [PATCH 3/7] percpu: clean up percpu variable definitions
References: <1243846708-805-1-git-send-email-tj@kernel.org>	<1243846708-805-4-git-send-email-tj@kernel.org> <20090601.024006.98975069.davem@davemloft.net>
In-Reply-To: <20090601.024006.98975069.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Tejun Heo <tj@kernel.org>
> Date: Mon,  1 Jun 2009 17:58:24 +0900
> 
>> --- a/arch/cris/include/asm/mmu_context.h
>> +++ b/arch/cris/include/asm/mmu_context.h
>> @@ -17,7 +17,7 @@ extern void switch_mm(struct mm_struct *prev, struct mm_struct *next,
>>   * registers like cr3 on the i386
>>   */
>>  
>> -extern volatile DEFINE_PER_CPU(pgd_t *,current_pgd); /* defined in arch/cris/mm/fault.c */
>> +DECLARE_PER_CPU(pgd_t *,current_pgd); /* defined in arch/cris/mm/fault.c */
>>  
>>  static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
>>  {
> 
> Yes volatile sucks, but might this break something?
> 
> Whether the volatile is actually needed or not, it's bad to have this
> kind of potential behavior changing nugget hidden in this seemingly
> inocuous change.  Especially if you're the poor soul who ends up
> having to debug it :-/

Shouldn't the "volatile" go inside the DECLARE_PER_CPU() with the rest
of the type?  [Disclaimer: I haven't actually looked.]

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

