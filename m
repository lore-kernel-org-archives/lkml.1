Return-Path: <linux-kernel-owner+w=401wt.eu-S937184AbXHGVdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937184AbXHGVdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936229AbXHGVCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:02:53 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:45738 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936225AbXHGVCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:02:51 -0400
Message-ID: <46B8DDF3.7050008@nortel.com>
Date: Tue, 07 Aug 2007 15:02:43 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Jerry Jiang <wjiang@resilience.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain> <20070806123551.a6c3c154.wjiang@resilience.com> <46B72C58.5030502@redhat.com> <46B894E4.4010501@nortel.com> <46B8D6D7.2020206@redhat.com>
In-Reply-To: <46B8D6D7.2020206@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2007 21:02:46.0793 (UTC) FILETIME=[4E449F90:01C7D936]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:

> But if you're not using SMP, the only way you get a race condition is if 
> your compiler is reordering instructions that have side effects which 
> are invisible to the compiler.  This can happen with MMIO registers, but 
> it's not an issue with an atomic_t we're declaring in real memory.

I refer back to the interrupt handler case.  Suppose we have:

while(!atomic_read(flag))
  	continue;

where flag is an atomic_t that is set in an interrupt handler, the 
volatile may be necessary on some architectures to force the compiler to 
re-read "flag" each time through the loop.

Without the "volatile", the compiler could be perfectly within its 
rights to evaluate "flag" once and create an infinite loop.

Now I'm not trying to say that we should explictly use "volatile" in 
common code, but that it is possible that it is required within the 
arch-specific atomic_t accessors even on uniprocessor systems.

Chris
