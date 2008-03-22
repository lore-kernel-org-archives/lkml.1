Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbYCVVMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbYCVVMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYCVVMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:12:34 -0400
Received: from gw.goop.org ([64.81.55.164]:55507 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbYCVVMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:12:33 -0400
Message-ID: <47E57546.9030403@goop.org>
Date: Sat, 22 Mar 2008 14:08:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to avoid spurious lockdep warnings?
References: <47E2ECF3.2050606@goop.org> <20080322134656.173de045@laptopd505.fenrus.org>
In-Reply-To: <20080322134656.173de045@laptopd505.fenrus.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Thu, 20 Mar 2008 16:02:11 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> In a Xen system, when a new pagetable is about to be put in use it is 
>> "pinned", meaning that each page in the pagetable is registered with
>> the hypervisor.  This is done in arch/x86/xen/mmu.c:pin_page().
>>
>> In order to make this efficient, the hypercalls for pinning are
>> batched, so that multiple pages are submitted at once in a single
>> multicall. While a page is batched pending the hypercall, its
>> corresponding pte_lock is held.
>>
>> This means that the code can end up holding multiple pte locks at
>> once, though it is guaranteed to never try to hold the same lock at
>> once. However, because these locks are in the same lock class, I get
>> a spurious warning from lockdep.  Is there some way I can get rid of
>> this warning?
>>     
>
>
> what's the ordering guarantee between these locks ?
>   

Pagetable virtual address order.  move_ptes can also lock two ptes 
within one pagetable, without regard to order, but they're protected by 
mmap_sem, which is also held during pinning.

    J
