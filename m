Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbYJ1IEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbYJ1IEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 04:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYJ1IEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 04:04:33 -0400
Received: from gw.goop.org ([64.81.55.164]:48196 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbYJ1IEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 04:04:32 -0400
Message-ID: <4906C789.7060408@goop.org>
Date: Tue, 28 Oct 2008 19:04:25 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: vm_unmap_aliases and Xen
References: <49010D41.1080305@goop.org> <200810281619.10388.nickpiggin@yahoo.com.au>
In-Reply-To: <200810281619.10388.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Friday 24 October 2008 10:48, Jeremy Fitzhardinge wrote:
>   
>> I've been having a few problems with Xen, I suspect as a result of the
>> lazy unmapping in vmalloc.c.
>>
>> One immediate one is that vm_unmap_aliases() will oops if you call it
>> before vmalloc_init() is called, which can happen in the Xen case.  RFC
>> patch below.
>>     
>
> Sure, we could do that. If you add an unlikely, and a __read_mostly,
> I'd ack it. Thanks for picking this up.
>   

OK, will respin accordingly.

>> But the bigger problem I'm seeing is that despite calling
>> vm_unmap_aliases() at the pertinent places, I'm still seeing errors
>> resulting from stray aliases.  Is it possible that vm_unmap_aliases()
>> could be missing some, or not completely synchronous?
>>     
>
> It's possible, but of course that would not be by design ;)
>
> I've had another look over it, and nothing obvious comes to
> mind.
>   

I found the problem and fixed it; I was just doing the operations in the 
wrong order.

Thanks,
    J
