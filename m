Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbYFYXzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbYFYXzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbYFYXyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:54:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53185 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYFYXyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:54:52 -0400
Message-ID: <4862D247.2010709@kernel.org>
Date: Wed, 25 Jun 2008 16:18:31 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 03 of 36] x86: add memory barriers to wrmsr
References: <patchbomb.1214367536@localhost>	<93c7057b1f4acae501b2.1214367539@localhost>	<20080624214441.13202f12@infradead.org>	<4862B3E9.50601@goop.org> <20080625153136.2b3b6737@infradead.org>
In-Reply-To: <20080625153136.2b3b6737@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>>>   
>> I suppose, though I would be inclined to put the barriers in the
>> wrmsr macro itself to act as documentation. 
> 
> 
> yeah I meant like this:
> 
> static inline void native_write_msr(unsigned int msr,
>  				    unsigned low, unsigned high)
> {
> 	barrier();
> 	asm volatile("wrmsr" : : "c" (msr), "a"(low), "d" (high));
> 	barrier();
> }
> 
> or in the same in the thing that calls this.
> 

Actually, I believe the barrier(); before is actually incorrect, since 
it would affect the wrmsr() register arguments rather than the wrmsr 
instruction itself.

	-hpa
