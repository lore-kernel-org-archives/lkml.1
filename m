Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbYIHPal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbYIHPal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbYIHPaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:30:18 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:41596 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953AbYIHPaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:30:17 -0400
Message-Id: <48C5613E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Mon, 08 Sep 2008 16:30:38 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v2)
References: <48C13D1C.76E4.0078.0@novell.com>
 <20080905150030.GD10292@elte.hu> <48C51F8D.76E4.0078.0@novell.com>
 <86802c440809080753u5c42d052l65c7690b45854115@mail.gmail.com>
In-Reply-To: <86802c440809080753u5c42d052l65c7690b45854115@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>                c->x86_virt_bits = (eax >> 8) & 0xff;
>>                c->x86_phys_bits = eax & 0xff;
>> +               /* CPUID workaround for Intel 0F33/0F34 CPU */
>> +               if (c->x86_vendor == X86_VENDOR_INTEL
>> +                   && c->x86 == 0xF && c->x86_model == 0x3
>> +                   && (c->x86_mask == 0x3
>> +                       || c->x86_mask == 0x4))
>> +                       c->x86_phys_bits = 36;
>
>these lines should be in early_init_intel/init_intel.
>also need to be checked if it could be overwriten by others functions later..

I think this should then be a follow-up patch.

>BTW, did you address Peter's concern?

Sorry, I don't recall anything else I needed to address.

Jan

