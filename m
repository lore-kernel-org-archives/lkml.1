Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbZFAJkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbZFAJkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbZFAJkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:40:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49054
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440AbZFAJkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:40:07 -0400
Date: Mon, 01 Jun 2009 02:40:06 -0700 (PDT)
Message-Id: <20090601.024006.98975069.davem@davemloft.net>
To: tj@kernel.org
Cc: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com,
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
From: David Miller <davem@davemloft.net>
In-Reply-To: <1243846708-805-4-git-send-email-tj@kernel.org>
References: <1243846708-805-1-git-send-email-tj@kernel.org>
	<1243846708-805-4-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Mon,  1 Jun 2009 17:58:24 +0900

> --- a/arch/cris/include/asm/mmu_context.h
> +++ b/arch/cris/include/asm/mmu_context.h
> @@ -17,7 +17,7 @@ extern void switch_mm(struct mm_struct *prev, struct mm_struct *next,
>   * registers like cr3 on the i386
>   */
>  
> -extern volatile DEFINE_PER_CPU(pgd_t *,current_pgd); /* defined in arch/cris/mm/fault.c */
> +DECLARE_PER_CPU(pgd_t *,current_pgd); /* defined in arch/cris/mm/fault.c */
>  
>  static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
>  {

Yes volatile sucks, but might this break something?

Whether the volatile is actually needed or not, it's bad to have this
kind of potential behavior changing nugget hidden in this seemingly
inocuous change.  Especially if you're the poor soul who ends up
having to debug it :-/
