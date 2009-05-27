Return-Path: <linux-kernel-owner+w=401wt.eu-S1762185AbZE0TGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185AbZE0TGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757326AbZE0TF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:05:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:49627 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759363AbZE0TFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:05:55 -0400
Cc: jeremy@goop.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Ian.Campbell@citrix.com
Message-Id: <92B9A919-0F13-43FA-8E01-4470065A9131@kernel.crashing.org>
From: Becky Bruce <beckyb@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090522194930E.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH V2 2/3] powerpc: Add support for swiotlb on 32-bit
Date: Wed, 27 May 2009 14:05:42 -0500
References: <4A1592CF.8000208@goop.org> <E6DAA792-9923-4B76-9759-6955AABE3EAB@kernel.crashing.org> <4A15B72E.2070202@goop.org> <20090522194930E.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 22, 2009, at 5:51 AM, FUJITA Tomonori wrote:

> On Thu, 21 May 2009 13:18:54 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>> Becky Bruce wrote:
>>> I can work with that, but it's going to be a bit inefficient, as I
>>> actually need the dma_addr_t, not the phys_addr_t, so I'll have to
>>> convert.  In every case, this is a conversion I've already done and
>>> that I need in the calling code as well.  Can we pass in both the
>>> phys_addr_t and the dma_addr_t?
>>
>> The Xen implementation would needs to do the phys to bus conversion  
>> page
>> by page anyway, so it wouldn't help much.  But it also wouldn't hurt.
>>
>> How expensive is the phys-to-bus conversion on power?  Is it worth
>> making the interface more complex for?  Would passing phys+bus mean  
>> that
>> we wouldn't also need to pass dev?
>
> I don't think so. POWERPC needs it.

Hrm, it looks like my response to this got dropped.  Fujita is correct  
- we still need the dev on powerpc because we use it to get device- 
specific information that is used to determining when we need to  
actually bounce.

Cheers,
B

