Return-Path: <linux-kernel-owner+w=401wt.eu-S934439AbXGUWKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934439AbXGUWKL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762973AbXGUWJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:09:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36193 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbXGUWJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:09:58 -0400
Message-ID: <46A28425.2010202@zytor.com>
Date: Sat, 21 Jul 2007 15:09:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Muli Ben-Yehuda <muli@il.ibm.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Create clflush() inline, remove hardcoded wbinvd
References: <1184885740.16311.19.camel@t60> <200707202119.l6KLJwcd004205@tazenda.hos.anvin.org> <20070721181137.GH4152@rhun.haifa.ibm.com> <46A263FA.70501@zytor.com> <20070721201634.GF1193@rhun.ibm.com> <46A26A2E.7070305@zytor.com> <20070721204458.GG1193@rhun.ibm.com>
In-Reply-To: <20070721204458.GG1193@rhun.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Muli Ben-Yehuda wrote:
> 
> Ok, let's try again:
> 
> You're changing this (pageattr.c)
> 
>                 asm volatile("clflush (%0)" :: "r" (adr + i));
> 
> into this:
> 
> 		asm volatile("clflush %0" : "+m" (*(char __force*)(adr + i)));
> 
> The original one calls clflush with (adr + i), the new one with (*(adr
> + i)). Are these calls equivalent?

Yes, they are.  The parentheses which are part of the old assembly
string has the same effect as the asterisk operator in C.

The difference between the two is that the latter form allows the C
compiler to select the addressing mode, which allows the full range of
addressing modes, whereas the former forces it to use a single register
indirect.

	-hpa
