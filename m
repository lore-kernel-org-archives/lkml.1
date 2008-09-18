Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbYIRSQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbYIRSQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbYIRSQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:16:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54441 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbYIRSQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:16:06 -0400
Message-ID: <48D29A0D.7020601@zytor.com>
Date: Thu, 18 Sep 2008 11:12:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v3)
References: <48D21BA3.76E4.0078.0@novell.com> <20080918071852.GA7639@elte.hu> <20080918091003.GA3751@elte.hu> <48D23BF6.76E4.0078.0@novell.com> <20080918095710.GA11633@elte.hu> <20080918112018.GA456@elte.hu> <48D25E87.76E4.0078.0@novell.com> <48D29741.4070404@goop.org>
In-Reply-To: <48D29741.4070404@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Is x86_phys_bits defined to be the actual number of address lines poking
> out of the CPU package, or the number of address bits we can
> meaningfully put into a pte?
> 

My opinion is that it should be the number of physical address bits 
available on the hardware, not as limited by the kernel.

> I would say the simplest thing to do here is be explicit:
> 
> 	if (sizeof(addr) == sizeof(u64))
> 		return !(addr >> boot_cpu_data.x86_phys_bits);
> 	else
> 		return 1; 
> 
> That's not ideal, but I guess its good enough.  I assume x86_phys_bits
> can never be less than 32?

Technically speaking the 386SX had 24 physical address bits.  We do not 
actually set it that way, and I'm not even sure how to detect the 386SX 
programmatically.

	-hpa

