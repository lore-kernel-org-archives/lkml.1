Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbYCUFjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbYCUFjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 01:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYCUFjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 01:39:16 -0400
Received: from gw.goop.org ([64.81.55.164]:57152 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbYCUFjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 01:39:16 -0400
Message-ID: <47E34917.8030206@goop.org>
Date: Thu, 20 Mar 2008 22:35:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to avoid spurious lockdep warnings?
References: <47E2ECF3.2050606@goop.org> <1206056698.6437.70.camel@lappy>
In-Reply-To: <1206056698.6437.70.camel@lappy>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2008-03-20 at 16:02 -0700, Jeremy Fitzhardinge wrote:
>   
>> In a Xen system, when a new pagetable is about to be put in use it is 
>> "pinned", meaning that each page in the pagetable is registered with the 
>> hypervisor.  This is done in arch/x86/xen/mmu.c:pin_page().
>>
>> In order to make this efficient, the hypercalls for pinning are batched, 
>> so that multiple pages are submitted at once in a single multicall.  
>> While a page is batched pending the hypercall, its corresponding 
>> pte_lock is held.
>>
>> This means that the code can end up holding multiple pte locks at once, 
>> though it is guaranteed to never try to hold the same lock at once.  
>> However, because these locks are in the same lock class, I get a 
>> spurious warning from lockdep.  Is there some way I can get rid of this 
>> warning?
>>     
>
> How many locks at once?

(We discussed this, but for the record...)

The main limit is the batch size, which is currently 32.  There's 
nothing magic about this number, so it may change (I can't imagine it 
getting much larger however, since a 32x mitigation of hypercall 
overhead is already pretty good).

    J
