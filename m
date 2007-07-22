Return-Path: <linux-kernel-owner+w=401wt.eu-S1763915AbXGVUCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763915AbXGVUCg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 16:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761403AbXGVUC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 16:02:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42553 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761262AbXGVUC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 16:02:27 -0400
Message-ID: <46A3B7C9.2050503@zytor.com>
Date: Sun, 22 Jul 2007 13:02:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Create clflush() inline, remove hardcoded wbinvd
References: <1184885740.16311.19.camel@t60> <200707202119.l6KLJwcd004205@tazenda.hos.anvin.org> <20070720212741.GB565@one.firstfloor.org> <46A12A3A.4020305@zytor.com> <20070722091826.GA28313@one.firstfloor.org> <46A39C64.9070301@zytor.com> <20070722195532.GA1432@one.firstfloor.org>
In-Reply-To: <20070722195532.GA1432@one.firstfloor.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Sun, Jul 22, 2007 at 11:05:24AM -0700, H. Peter Anvin wrote:
>> Andi Kleen wrote:
>>>> The main reason is that everyone seems to invoke it either incorrectly
>>> Where is it incorrect? 
>> Using "r" or "m" (as opposed as "+m") gives gcc the wrong dependency
>> information, and it could, at least in theory, cause memory references
>> to be moved around it -- especially when using "r".
> 
> That doesn't sound correct. Taking the address should be like an escaping
> pointer and equivalent to read/write and effectively disable optimizations
> on this memory.

It might be in the existing gcc for all I know, but there is no explicit
guarantee to that effect.  Remember that inline assembly is really
nothing but the guts of gcc exposed to the programmer, and that the gcc
people are very blunt about not wanting to muck with the former to suit
the latter.  This means that there are a lot of things that may
accidentally work in one version of gcc which breaks in another.

There are two documented ways to tell gcc that you're mucking with
memory, and those are "m" constraints ("m" read, "=m" write, "+m"
read/write) and "memory" clobbers; the latter which affects all memory.

	-hpa
