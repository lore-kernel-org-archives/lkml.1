Return-Path: <linux-kernel-owner+w=401wt.eu-S1761779AbXKHVAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761779AbXKHVAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 16:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbXKHVAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 16:00:06 -0500
Received: from gw.goop.org ([64.81.55.164]:35691 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbXKHVAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 16:00:05 -0500
Message-ID: <473378B3.1090700@goop.org>
Date: Thu, 08 Nov 2007 12:59:31 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <glommer@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Zach Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC 3/7] x86: clean up asm-x86/page*.h
References: <20071108015008.660012621@goop.org>	 <20071108015310.218076184@goop.org> <5d6222a80711080842i201cb431le966d5069d59db24@mail.gmail.com>
In-Reply-To: <5d6222a80711080842i201cb431le966d5069d59db24@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> On Nov 7, 2007 11:50 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   
>> +#define PAGETABLE_LEVELS       3
>> +
>> +typedef u64    pteval_t;
>> +typedef u64    pmdval_t;
>> +typedef u64    pudval_t;
>> +typedef u64    pgdval_t;
>> +
>>     
>
>   
>> -static inline unsigned long long native_pgd_val(pgd_t pgd)
>> +static inline pgdval_t native_pgd_val(pgd_t pgd)
>>  {
>>     
> Maybe these kind of things, the typedef and native_xxx definitions can
> go into the common header, after we define the PAGETABLE_LEVELS
> constant?
> I think the more goes into common headers, the better.
>   

You mean put them in a common header, but conditionally by #if
PAGETABLE_LEVELS?  I don't think that would be much of an improvement;
it would just add more #ifs, which adds lines and conceptual
complexity.  If you go that way, you may as well put everything in one
header wrapped in #ifs, but personally I don't think that would help.

    J
