Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbYLYRkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbYLYRkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 12:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYLYRkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 12:40:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33577 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbYLYRki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 12:40:38 -0500
Message-ID: <4953C57F.70502@redhat.com>
Date: Thu, 25 Dec 2008 19:40:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joerg.roedel@amd.com>,
       Benjamin Serebrin <benjamin.serebrin@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Alexander Graf <agraf@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: kvm vmload/vmsave vs tss.ist
References: <49539FD0.7070103@redhat.com> <20081225151757.GA25117@elte.hu> <4953AAE5.4000708@redhat.com> <20081225162107.GB14486@elte.hu> <20081225164232.GA25195@elte.hu>
In-Reply-To: <20081225164232.GA25195@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> i'd suggest to reuse the irq-stacks for this. Right now on 64-bit we've 
>> got the following stack layout: 8K process stacks, a 16K IRQ stack on 
>> each CPU, shared by all IRQs. Then we have the IST stacks with weird 
>> sizes: debug:8K, the others: 4K.
>>     
>
> this has to be done carefully though, as there's a subtle detail here: 
> right now the pda_irqcount and the pda_irqstackptr logic in entry_64.S is 
> not re-entry safe and relies on IRQs being off.
>
> If critical exceptions are moved to the IRQ stack then %rsp switching to 
> the IRQ stack has to be done atomically: instead of using the pda_irqcount 
> check the %rsp value itself should be checked against pda_irqstackptr - if 
> it's within that 16K range then we are already on the IRQ stack and do not 
> need to switch to it but can just use the current %rsp.
>   

I think it's enough to switch %rsp before incrementing irqcount, no?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

