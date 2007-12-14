Return-Path: <linux-kernel-owner+w=401wt.eu-S1760912AbXLNIoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912AbXLNIoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 03:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbXLNIoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 03:44:21 -0500
Received: from gw.goop.org ([64.81.55.164]:39378 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbXLNIoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 03:44:20 -0500
Message-ID: <47624253.7060507@goop.org>
Date: Fri, 14 Dec 2007 00:44:03 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Glauber de Oliveira Costa <glommer@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] x86: clean up asm-x86/page*.h
References: <47623AD6.6090403@goop.org> <47624D81.76E4.0078.0@novell.com>
In-Reply-To: <47624D81.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>> --- a/arch/x86/mm/fault_64.c
>> +++ b/arch/x86/mm/fault_64.c
>> @@ -158,22 +158,22 @@ void dump_pagetable(unsigned long addres
>> 	pgd = __va((unsigned long)pgd & PHYSICAL_PAGE_MASK); 
>> 	pgd += pgd_index(address);
>> 	if (bad_address(pgd)) goto bad;
>> -	printk("PGD %lx ", pgd_val(*pgd));
>> +	printk("PGD %lx ", (unsigned long)pgd_val(*pgd));
>>     
>
> Casts like this here and elsewhere look rather odd (in fact I think using
> casts should really be limited to places where you either can't do it
> differently or the code would become badly readable or much uglier
> without them). I would therefore favor simply using the right formatting
> specifier here.

I would agree, but pgd_val() is defined as returning a pgdval_t, which
is typedefed to be unsigned long.  I'll have another look, but I don't
think there's an appropriate format for this.

    J
