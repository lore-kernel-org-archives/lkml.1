Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbYAKKK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbYAKKK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 05:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbYAKKKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 05:10:15 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:35249
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671AbYAKKKO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 05:10:14 -0500
Message-Id: <47874E3C.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 11 Jan 2008 10:08:44 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
       "Jeremy Fitzhardinge" <jeremy@xensource.com>
Subject: Re: [PATCH] adjust/fix LDT handling for Xen
References: <4787436E.76E4.0078.0@novell.com> <47873959.3000102@gmail.com>
In-Reply-To: <47873959.3000102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- linux-2.6.24-rc7/arch/x86/kernel/ldt_32.c	2008-01-10 16:53:54.000000000 +0100
>> +++ 2.6.24-rc7-x86-xen-ldt/arch/x86/kernel/ldt_32.c	2008-01-09 13:59:50.000000000 +0100
>[...]
>> @@ -73,7 +72,7 @@ static int alloc_ldt(mm_context_t *pc, u
>>  		if (oldsize*LDT_ENTRY_SIZE > PAGE_SIZE)
>>  			vfree(oldldt);
>>  		else
>> -			kfree(oldldt);
>> +			put_page(virt_to_page(oldldt));
>>  	}
>>  	return 0;
>>  }
>> @@ -117,7 +116,7 @@ void destroy_context(struct mm_struct *m
>>  		if ((unsigned)mm->context.size*LDT_ENTRY_SIZE > PAGE_SIZE)
>>  			vfree(mm->context.ldt);
>>  		else
>> -			kfree(mm->context.ldt);
>> +			put_page(virt_to_page(mm->context.ldt));
>
>why not free_page() with all those checks if it is correct virt address which it 
>brings?

I followed the combination I found elsewhere - __get_free_page/put_page
or alloc_page/free_page. I admit that I'm unclear about when/why to use
one vs. the other pair.

Jan

