Return-Path: <linux-kernel-owner+w=401wt.eu-S1761290AbYEVXDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbYEVXDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 19:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbYEVXDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 19:03:43 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:36169 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbYEVXDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 19:03:43 -0400
Date: Thu, 22 May 2008 15:56:52 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: David Miller <davem@davemloft.net>, scottwood@freescale.com,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
In-Reply-To: <1211516683.8297.271.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0805221553400.8205@t2.domain.actdsltmp>
References: <4833524C.3040207@freescale.com>  <20080520.153947.84346222.davem@davemloft.net>
  <4833542E.3040608@freescale.com>  <20080520.155326.195407196.davem@davemloft.net>
 <1211516683.8297.271.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008, Benjamin Herrenschmidt wrote:
> On Tue, 2008-05-20 at 15:53 -0700, David Miller wrote:
>> From: Scott Wood <scottwood@freescale.com>
>> Date: Tue, 20 May 2008 17:43:58 -0500
>>> David Miller wrote:
>>>> The __volatile__ in the asm construct disallows movement of the
>>>> inline asm relative to statements surrounding it.
>>>>
>>>> The only reason barrier() in kernel.h needs a memory clobber is
>>>> because of a bug in ancient versions of gcc.  In fact, I think
>>>> that memory clobber might even be removable.
>>>
>>> Current versions of GCC seem quite happy to move non-asm memory accesses
>>> around a volatile asm without a memory clobber; see the test Trent posted.
>>
>> Indeed, and even the GCC manual is clear about this.
>
> So what is the scope of that problem ?
>
> IE. Take an x86 version of that test, writing to memory, doing a writel
> to some MMIO, then another memory write, can those be re-ordered with
> the current x86 version of writel ?

Yes, the same thing can happen on x86.  As far as I could tell, this is
something that all other arches can have happen.  Usually aliasing prevents
it, but it's not hard to constuct a test case where it doesn't.
