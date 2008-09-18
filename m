Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbYIRXli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbYIRXli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 19:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755678AbYIRXl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 19:41:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60972 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbYIRXl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 19:41:27 -0400
Message-ID: <48D2E65A.6020004@redhat.com>
Date: Thu, 18 Sep 2008 16:38:02 -0700
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: Populating multiple ptes at fault time
References: <48D142B2.3040607@goop.org> <48D17E75.80807@redhat.com> <48D1851B.70703@goop.org> <48D18919.9060808@redhat.com> <48D18C6B.5010407@goop.org> <48D2B970.7040903@redhat.com> <48D2D3B2.10503@goop.org>
In-Reply-To: <48D2D3B2.10503@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Avi Kivity wrote:
>   
>>> Do you need to set the A bit synchronously?  
>>>       
>> Yes, of course (if no guest cooperation).
>>     
>
> Is the A bit architecturally guaranteed to be synchronously set?  

I believe so.  The cpu won't cache tlb entries with the A bit clear 
(much like the shadow code), and will rmw the pte on first access.

> Can
> speculative accesses set it?  

Yes, but don't abuse this.

>> If we add an async mode for guests that can cope, maybe this is
>> workable.  I guess this is what you're suggesting.
>>
>>     
>
> Yes.  At worst Linux would underestimate the process RSS a bit
> (depending on how many unsynchronized ptes you leave lying around).  I
>   

Not the RSS (that's pte.present pages) but the working set (aka active 
list).

> bet there's an appropriate pvop hook you could use to force
> synchronization just before the kernel actually inspects the bits
> (leaving lazy mode sounds good).
>   

It would have to be a new lazy mode, not the existing one, I think.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

