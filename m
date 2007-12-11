Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbXLKQwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbXLKQwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 11:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbXLKQvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 11:51:43 -0500
Received: from gw.goop.org ([64.81.55.164]:44967 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbXLKQvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 11:51:42 -0500
Message-ID: <475EC01D.5090800@goop.org>
Date: Tue, 11 Dec 2007 08:51:41 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 5/4] x86: fix up asm-x86/pgtable*.h formatting
References: <475DA7C5.70900@goop.org> <20071211083413.GA19953@infradead.org>
In-Reply-To: <20071211083413.GA19953@infradead.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Dec 10, 2007 at 12:55:33PM -0800, Jeremy Fitzhardinge wrote:
>   
>> +#define set_pte_atomic(pteptr, pteval)		set_pte(pteptr,pteval)
>> +#define set_pte_present(mm,addr,ptep,pteval)	set_pte_at(mm,addr,ptep,pteval)
>>  
>> +#define pte_clear(mm,addr,xp)				\
>> +	do {						\
>> +		set_pte_at(mm, addr, xp, __pte(0));	\
>> +	} while (0)
>> +
>>  #undef pmd_clear
>> +#define pmd_clear(xp)				\
>> +	do {					\
>> +		set_pmd(xp, __pmd(0));		\
>> +	} while (0)
>>     
>
> What about turning these into inline functions to get better type
> checking?
>   

I'll give it a go.  Some of these need to be macros because of #include
hell; I'm not sure if that applies to these ones.

    J
