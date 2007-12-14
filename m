Return-Path: <linux-kernel-owner+w=401wt.eu-S1762282AbXLNIxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762282AbXLNIxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 03:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbXLNIw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 03:52:57 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:30350
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754489AbXLNIw4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 03:52:56 -0500
Message-Id: <476252AF.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 14 Dec 2007 08:53:51 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Glauber de Oliveira Costa" <glommer@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] x86: clean up asm-x86/page*.h
References: <47623AD6.6090403@goop.org> <47624D81.76E4.0078.0@novell.com>
 <47624253.7060507@goop.org>
In-Reply-To: <47624253.7060507@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 14.12.07 09:44 >>>
>Jan Beulich wrote:
>>> --- a/arch/x86/mm/fault_64.c
>>> +++ b/arch/x86/mm/fault_64.c
>>> @@ -158,22 +158,22 @@ void dump_pagetable(unsigned long addres
>>> 	pgd = __va((unsigned long)pgd & PHYSICAL_PAGE_MASK); 
>>> 	pgd += pgd_index(address);
>>> 	if (bad_address(pgd)) goto bad;
>>> -	printk("PGD %lx ", pgd_val(*pgd));
>>> +	printk("PGD %lx ", (unsigned long)pgd_val(*pgd));
>>>     
>>
>> Casts like this here and elsewhere look rather odd (in fact I think using
>> casts should really be limited to places where you either can't do it
>> differently or the code would become badly readable or much uglier
>> without them). I would therefore favor simply using the right formatting
>> specifier here.
>
>I would agree, but pgd_val() is defined as returning a pgdval_t, which
>is typedefed to be unsigned long.  I'll have another look, but I don't
>think there's an appropriate format for this.

Typedef-s can be printed with the same format specifier as the underlying
type. But u64 is (at least in plain -rc5) a typedef of 'unsigned long long', so
the compiler validly warns about the use of 'l' there, and I would assume it's
those compiler warnings that you want to get rid of...

Jan

