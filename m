Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbZEKSmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbZEKSmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZEKSmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:42:43 -0400
Received: from gw.goop.org ([64.81.55.164]:46149 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbZEKSmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:42:43 -0400
Message-ID: <4A0871A2.9050502@goop.org>
Date: Mon, 11 May 2009 11:42:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 1/9] xen: make sure swiotlb allocation is physically	contigious
References: <1241741842-7966-1-git-send-email-jeremy@goop.org> <1241741842-7966-2-git-send-email-jeremy@goop.org> <20090511135532.GA8671@8bytes.org>
In-Reply-To: <20090511135532.GA8671@8bytes.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
>> +}
>> +
>> +void *swiotlb_alloc(unsigned order, unsigned long nslabs)
>> +{
>> +	/* Never called on x86.  Warn, just in case. */
>>     
>
> Can't this function be removed completly then?
>   

The swiotlb code contains a static call, which never ends up being 
executed, so there has to be something to be called.  But you're right 
that there's no particular reason for this warning unless someone starts 
to call swiotlb_alloc in the future.

I'd briefly discussed the idea of eliminating the distinction between 
boot and post-boot swiotlb allocation, but it looks tricky to implement.

>> +
>> +	if (xen_create_contiguous_region((unsigned long)buf,
>> +					 order, 0xffffffff))
>>     
>                                                 DMA_32BIT_MASK?
>   

OK (ditto other mentions).

    J
