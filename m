Return-Path: <linux-kernel-owner+w=401wt.eu-S934188AbXHHFkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934188AbXHHFkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 01:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbXHHFjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 01:39:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbXHHFjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 01:39:54 -0400
Message-ID: <46B95715.2090108@redhat.com>
Date: Wed, 08 Aug 2007 01:39:33 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Jerry Jiang <wjiang@resilience.com>
CC: Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain>	<20070806123551.a6c3c154.wjiang@resilience.com>	<46B72C58.5030502@redhat.com>	<46B894E4.4010501@nortel.com>	<46B8D6D7.2020206@redhat.com> <20070808102705.9d91a14c.wjiang@resilience.com>
In-Reply-To: <20070808102705.9d91a14c.wjiang@resilience.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jerry Jiang wrote:
> On Tue, 07 Aug 2007 16:32:23 -0400
> Chris Snook <csnook@redhat.com> wrote:
> 
>>> It seems like this would fall more into the case of the arch providing 
>>> guarantees when using locked/atomic access rather than anything 
>>> SMP-related, no?.
>> But if you're not using SMP, the only way you get a race condition is if your 
>> compiler is reordering instructions that have side effects which are invisible 
>> to the compiler.  This can happen with MMIO registers, but it's not an issue 
>> with an atomic_t we're declaring in real memory.
>>
> 
> Under non-SMP, some compilers would reordering instructions as they think
> and C standard informally guarantees all operations on volatile data
> are executed in the sequence in which they appear in the source code,
> right?
> 
> So no reordering happens with volatile, right?

Plenty of reordering happens with volatile, but on VLIW, EPIC, and 
similar architectures, it ensures that accesses to the variable in 
question will not be compiled into instruction slots that can execute 
simultaneously.

	-- Chris
