Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbZFALhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbZFALhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 07:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZFALhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 07:37:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:45361 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472AbZFALhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 07:37:43 -0400
Message-ID: <4A23BD20.5030500@kernel.org>
Date: Mon, 01 Jun 2009 20:36:00 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, paulus@samba.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, chris@zankel.net, rusty@rustcorp.com.au,
       jens.axboe@oracle.com, davej@redhat.com, jeremy@xensource.com,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/7] percpu: clean up percpu variable definitions
References: <1243846708-805-1-git-send-email-tj@kernel.org>	<1243846708-805-4-git-send-email-tj@kernel.org> <20090601.024006.98975069.davem@davemloft.net>
In-Reply-To: <20090601.024006.98975069.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Jun 2009 11:36:03 +0000 (UTC)
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

You're right.  Aieee... how do I feed volatile to the DEFINE macro.
I'll think of something.

Thanks.

-- 
tejun
