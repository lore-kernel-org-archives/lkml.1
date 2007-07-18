Return-Path: <linux-kernel-owner+w=401wt.eu-S1764116AbXGRF7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764116AbXGRF7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 01:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXGRF7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 01:59:25 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:34929
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762696AbXGRF7Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 01:59:24 -0400
Message-Id: <469DC8B8.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 18 Jul 2007 07:00:56 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [PATCH] x86: make SMP locks handling interact properly
	with CONFIG_DEBUG_RODATA (2nd try)
References: <468B5B54.76E4.0078.0@novell.com>
 <200707171954.34541.ak@suse.de>
In-Reply-To: <200707171954.34541.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>  void alternatives_smp_module_del(struct module *mod)
>>  {
>>  	struct smp_alt_module *item;
>> -	unsigned long flags;
>>  
>>  	if (smp_alt_once || noreplace_smp)
>>  		return;
>>  
>> -	spin_lock_irqsave(&smp_alt, flags);
>> +	spin_lock(&smp_alt);
>
>Unrelated change?  Why? Should probably be separate patch.

Absolutely not: You can't call change_page_attr(), or more precisely
global_flush_tlb(), with interrupts disabled. And since interrupt disabling
is unneeded here afaics, I simply changed the calls instead of inventing
some ugly workaround.

I'll do the other adjustments you asked for, but it'll be only in about three
weeks from now...

Jan

