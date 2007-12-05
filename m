Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbXLEJbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbXLEJbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 04:31:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbXLEJax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 04:30:53 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:33571
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270AbXLEJaw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 04:30:52 -0500
Message-Id: <47567DF8.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 05 Dec 2007 09:31:20 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Luca" <luca.b633@gmail.com>, "Andrew Pinski" <pinskia@gmail.com>
Cc: <gcc@gcc.gnu.org>, <binutils@sourceware.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] 32-bit pointers in x86-64
References: <1ba5638c0711250829o416e3ccasba572d3c205ea7f4@mail.gmail.com>
 <de8d50360711251045l4566f894m92fbb32d00fa362@mail.gmail.com>
In-Reply-To: <de8d50360711251045l4566f894m92fbb32d00fa362@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "Andrew Pinski" <pinskia@gmail.com> 25.11.07 19:45 >>>
>On 11/25/07, Luca <luca.b633@gmail.com> wrote:
>> 7.1. Add __attribute__((pointer_size(XXX))) and #pragma pointer_size
>> to allow 64-bit pointers in 32-bit mode and viceversa
>
>This is already there, try using __attribute__((mode(DI) )).

Hmm, unless this is a new feature in 4.3, I can't seem to get this to work on
either i386 (using mode DI) or x86-64 (using mode SI). Could you clarify? If
this worked consistently on at least all 64-bit architectures, I would have a
use for it in the kernel (cutting down the kernel size by perhaps several
pages). Btw., I continue to think that the error message 'initializer element
is not computable at load time' on 64-bit code like this

extern char array[];
unsigned int p = (unsigned long)array;

or 32-bit code like this

extern char array[];
unsigned long long p = (unsigned long)array;

is incorrect - the compiler generally has no knowledge what 'array' is (it may
know whether the architecture is generally capable of expressing the
necessary relocation, but if 'array' is really a placeholder for an assembly
level constant, possibly even defined through __asm__() in the same
translation unit, this diagnostic should at best be a warning). I'm pretty
sure I have an open bug for this, but the sad thing is that bugs like this
never appear to really get looked at.

Thanks, Jan

