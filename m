Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbZEWW7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbZEWW7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 18:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZEWW70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 18:59:26 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:44534 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZEWW7Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 18:59:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DxwqnLFuw8hvLz9vlTh048McosDKxIduEvM6R3RoDtAFxykIzHEWa1kLmTttQiTE4K
         z50Te3hJMNC/hvGoZZq/iTOAamwVMamRaKUfiVlp4labnPI6v+HYXYirajt1mFSPQwPM
         7LWLvWEZnLWIXzVca3VSsVwnz2/l04uzSdJOA=
MIME-Version: 1.0
In-Reply-To: <4A173B72.5000201@goop.org>
References: <1242340949-16369-1-git-send-email-beckyb@kernel.crashing.org>
	 <1242340949-16369-2-git-send-email-beckyb@kernel.crashing.org>
	 <20090519142656T.fujita.tomonori@lab.ntt.co.jp>
	 <19E48A70-3332-423C-ACAD-390F940EE81C@kernel.crashing.org>
	 <4A1592CF.8000208@goop.org>
	 <E6DAA792-9923-4B76-9759-6955AABE3EAB@kernel.crashing.org>
	 <1242990702.22654.253.camel@zakaz.uk.xensource.com>
	 <4A173B72.5000201@goop.org>
Date: Sun, 24 May 2009 00:59:26 +0200
Message-ID: <c384c5ea0905231559i5ffb0637te62ee005074f9435@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] powerpc: Add support for swiotlb on 32-bit
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Becky Bruce <beckyb@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, May 23, 2009 at 1:55 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Ian Campbell wrote:
>>
>> On Thu, 2009-05-21 at 14:27 -0400, Becky Bruce wrote:
>>
>>>
>>> I can work with that, but it's going to be a bit inefficient, as I
>>>  actually need the dma_addr_t, not the phys_addr_t, so I'll have to
>>>  convert.  In every case, this is a conversion I've already done and  that I
>>> need in the calling code as well.
>>
>> Does
>>
>>    dma_addr_t dma_map_range(struct device *hwdev, phys_addr_t addr,
>>    size_t size);
>>
>> work for you?
>>
>> If the range does not need mapping then it returns the dma address, if
>> you needed to calculate the dma address anyway to figure out if mapping
>> is required then this is fine. If the range does need mapping then it
>> returns NULL.
>>
>
> My only concern is whether dma_addr_t == 0 is actually equivalent to NULL.
>  That is, can we be sure that address 0 will never be used?
>
Indeed, I remember seeing 0 returned on pci_alloc_coherent() as an
address (cookie).

Regards,
-- 
Leon
