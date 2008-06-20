Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbYFTG6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbYFTG6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 02:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbYFTG6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 02:58:00 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:5794 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbYFTG6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 02:58:00 -0400
Message-Id: <485B712C.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 20 Jun 2008 07:58:20 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] i386: fix vmalloc_sync_all() for Xen
References: <48591049.76E4.0078.0@novell.com> <485969A4.6090406@goop.org>
 <485A465D.76E4.0078.0@novell.com> <485A7122.8090200@goop.org>
 <485A9EF5.76E4.0078.0@novell.com> <485AA296.6070008@goop.org>
In-Reply-To: <485AA296.6070008@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I think it would be better to separately test whether the vmalloc 
>mapping is present in the init_mm and skip the syncing loop in that 
>case, rather than this somewhat convoluted logic to overload the test in 
>vmalloc_sync_one.

That's what the x86-64 code does. When I wrote this originally, I tried
to keep the pre-existing logic as much as possible, so I split out
vmalloc_sync_one() by mostly moving existing code. I certainly agree
that this has room for cleaning up (and then possibly including unification
with x86-64).

>>>> This is a replacement of the BUG_ON() that an earlier patch from you
>>>> removed: Failure of vmalloc_sync_one() must happen on the first
>>>> entry or never, and this is what is being checked for here.
>>>>   
>>>>       
>>> Could you add a comment?
>>>     
>>
>> Sure, though there was none originally, and the intention seemed
>> quite clear to me.
>
>Well, looks to me like vmalloc_sync_one can only return NULL iff the 
>vmalloc mapping is absent in init_mm, so that's going to be invariant 

Correct.

>with respect to any other pgd you pass in.  So I don't think the BUG_ON 
>will ever fire, and it's unclear what actual logical property it's 
>testing for.

My point of adding the BUG_ON() is that in vmalloc_sync_all() it is not
clear that vmalloc_sync_one() can fail only due to init_mm's page table
not being appropriately populated. So yes, this BUG_ON() is not
expected to ever fire - but isn't that a property of all BUG_ON()'s?

Jan

