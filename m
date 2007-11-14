Return-Path: <linux-kernel-owner+w=401wt.eu-S1763352AbXKNTEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763352AbXKNTEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbXKNTEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:04:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54182 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbXKNTEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:04:44 -0500
Message-ID: <473B45C4.5030501@zytor.com>
Date: Wed, 14 Nov 2007 11:00:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Immediate Values x86 Optimization Declare Discarded	Instruction
References: <20071113194550.GA4400@Krystal> <473A017D.2030501@zytor.com> <20071113204033.GB7450@Krystal> <473A166E.3070708@zytor.com> <20071113220227.GB9057@Krystal> <473A26A2.7090007@zytor.com> <20071114003409.GA18032@Krystal> <473A4909.1020609@zytor.com> <20071114014445.GB19901@Krystal> <473A6471.4040700@zytor.com> <20071114185220.GA29533@Krystal>
In-Reply-To: <20071114185220.GA29533@Krystal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> nitpicking :
> 
>> 	.section __discard,"a",@progbits
> 
> could we simply declare a 
> 
>      .section __discard,"",@progbits instead ?
> 
> I think this should remove the need to tweak the linker script, since
> the section would not be allocated.
> 

The allocation flag is a loader property, not a linker property.  It 
would still be manifest in the vmlinux file; I think this is 
undesirable.  Perhaps not a big deal, but neither is adding a /DISCARD/ 
statement to the linker script:

/DISCARD/ : { *(__discard) }

	-hpa
