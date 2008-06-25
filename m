Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYFYXGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYFYXGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbYFYXGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:06:25 -0400
Received: from gw.goop.org ([64.81.55.164]:35459 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbYFYXGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:06:24 -0400
Message-ID: <4862CF57.1010106@goop.org>
Date: Wed, 25 Jun 2008 16:05:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 03 of 36] x86: add memory barriers to wrmsr
References: <patchbomb.1214367536@localhost>	<93c7057b1f4acae501b2.1214367539@localhost>	<20080624214441.13202f12@infradead.org>	<4862B3E9.50601@goop.org> <20080625153136.2b3b6737@infradead.org>
In-Reply-To: <20080625153136.2b3b6737@infradead.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 25 Jun 2008 14:08:57 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Arjan van de Ven wrote:
>>     
>>> it's more readable for several of these cases to stick a barrier();
>>> in front and after it to be honest; that makes it more explicit that
>>> these are deliberate compiler barriers rather than "actual" memory
>>> access...
>>>
>>>   
>>>       
>> I suppose, though I would be inclined to put the barriers in the
>> wrmsr macro itself to act as documentation. 
>>     
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
>   

OK, we're in vehement agreement then.

    J

