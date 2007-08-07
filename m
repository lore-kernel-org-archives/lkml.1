Return-Path: <linux-kernel-owner+w=401wt.eu-S935754AbXHGWqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935754AbXHGWqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbXHGWqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:46:13 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:64718 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbXHGWqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:46:12 -0400
Message-ID: <46B8F62C.6030607@nortel.com>
Date: Tue, 07 Aug 2007 16:46:04 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Jerry Jiang <wjiang@resilience.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain> <20070806123551.a6c3c154.wjiang@resilience.com> <46B72C58.5030502@redhat.com> <46B894E4.4010501@nortel.com> <46B8D6D7.2020206@redhat.com> <46B8DDF3.7050008@nortel.com> <46B8E1D3.8050501@redhat.com> <46B8E64E.7010708@nortel.com> <46B8EBD8.9080101@redhat.com>
In-Reply-To: <46B8EBD8.9080101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2007 22:46:07.0668 (UTC) FILETIME=[BE470F40:01C7D944]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> Chris Friesen wrote:
>> Without other restrictions, a suficiently 
>> intelligent optimiser could notice that the address of v doesn't 
>> change in the loop and the destination is never written within the 
>> loop, so the read could be hoisted out of the loop.

> That would be a compiler bug.

Could you elaborate?  From the point of view of the compiler, it "knows" 
that the variable doesn't change inside the loop.

In the "volatile considered evil" discussion in May of this year, Alan 
Cox explicitly mentioned the implementation of atomic primitives as a 
case where "volatile" might be required.

> On most superscalar architectures, including powerpc, multiple 
> instructions can be in flight simultaneously, potentially even reading 
> and writing the same data.  When the compiler detects data dependencies 
> within a thread of execution, it will do the right thing.

In the example I gave, as far as the compiler can detect there are no 
dependencies.  The code that changes the value is in a different 
compilation unit.

> Modern ISAs that lack legacy baggage do away 
> with this guarantee, putting the burden on the compiler to enforce 
> serialization.  When the compiler can't detect that it's needed, we use 
> volatile to inform it explicitly.

I certainly agree with this statement.

This leads logically to the question of whether there are cases where 
the compiler cannot detect that serialization is needed when 
implementing atomic_t accessor functions.  Previously in this thread 
you've said that there are not, while I've attempted to show that it is 
possible.

Chris
