Return-Path: <linux-kernel-owner+w=401wt.eu-S935082AbXGTXFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935082AbXGTXFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 19:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936637AbXGTXFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 19:05:16 -0400
Received: from quark.didntduck.org ([69.55.226.66]:56329 "EHLO
	quark.didntduck.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934212AbXGTXFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 19:05:10 -0400
Message-ID: <46A13F9C.6020107@didntduck.org>
Date: Fri, 20 Jul 2007 19:05:00 -0400
From: Brian Gerst <bgerst@didntduck.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Frederik Deweerdt <deweerdt@free.fr>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
Subject: Re: [PATCH] Use descriptor's functions instead of inline assembly
References: <1184939761.16311.22.camel@t60> <20070720142319.GA23448@slug>
In-Reply-To: <20070720142319.GA23448@slug>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frederik Deweerdt wrote:
> On Fri, Jul 20, 2007 at 10:56:01AM -0300, Glauber de Oliveira Costa wrote:
>> This patch provides a new set of functions for managing the descriptor
>> tables that can be used instead of putting the raw assembly in .c files.
>>     
>> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
>>
>> -	asm volatile ("str %0"  : "=m" (ctxt->tr));
>> +	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
>> +	store_idt((struct desc_ptr *)&ctxt->idt_limit);
>> +	ctxt->tr = store_tr();
>>  
> Would'nt a store_tr(&ctxt->tr) be more homogeneous here?

Not really.  The task register is a segment number (a simple integer),
while the sidt/sgdt instructions write the cached descriptor to memory.

--
				Brian Gerst
