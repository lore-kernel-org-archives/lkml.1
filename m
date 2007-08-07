Return-Path: <linux-kernel-owner+w=401wt.eu-S935079AbXHGUcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935079AbXHGUcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760575AbXHGUcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:32:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760806AbXHGUcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:32:45 -0400
Message-ID: <46B8D6D7.2020206@redhat.com>
Date: Tue, 07 Aug 2007 16:32:23 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Jerry Jiang <wjiang@resilience.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain> <20070806123551.a6c3c154.wjiang@resilience.com> <46B72C58.5030502@redhat.com> <46B894E4.4010501@nortel.com>
In-Reply-To: <46B894E4.4010501@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Chris Snook wrote:
> 
>> If your architecture doesn't support SMP, the volatile keyword doesn't 
>> do anything except add a useless memory fetch.
> 
> I was under the impression that there were other cases as well 
> (interrupt handlers, for instance) where the value could be modified 
> "behind the back" of the current code.

When you're accessing data that could be modified by an interrupt handler, you 
generally use a function that calls arch-specific inline assembler to explicitly 
fetch it from memory.

> It seems like this would fall more into the case of the arch providing 
> guarantees when using locked/atomic access rather than anything 
> SMP-related, no?.

But if you're not using SMP, the only way you get a race condition is if your 
compiler is reordering instructions that have side effects which are invisible 
to the compiler.  This can happen with MMIO registers, but it's not an issue 
with an atomic_t we're declaring in real memory.

	-- Chris
