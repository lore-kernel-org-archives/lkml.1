Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbZBESzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbZBESzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZBESyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:54:52 -0500
Received: from gw.goop.org ([64.81.55.164]:38773 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbZBESyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:54:52 -0500
Message-ID: <498B35F9.601@goop.org>
Date: Thu, 05 Feb 2009 10:54:49 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: William Lee Irwin III <wli@holomorphy.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: pud_bad vs pud_bad
References: <498B2EBC.60700@goop.org> <20090205184355.GF5661@elte.hu>
In-Reply-To: <20090205184355.GF5661@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> I'm looking at unifying the 32 and 64-bit versions of pud_bad.
>>
>> 32-bits defines it as:
>>
>> static inline int pud_bad(pud_t pud)
>> {
>> 	return (pud_val(pud) & ~(PTE_PFN_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
>> }
>>
>> and 64 as:
>>
>> static inline int pud_bad(pud_t pud)
>> {
>> 	return (pud_val(pud) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
>> }
>>
>>
>> I'm inclined to go with the 64-bit version, but I'm wondering if there's 
>> something subtle I'm missing here.
>>     
>
> Why go with the 64-bit version? The 32-bit check looks more compact and 
> should result in smaller code.
>   

Well, its stricter.  But I don't really understand what condition its 
actually testing for.

    J
