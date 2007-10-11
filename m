Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbXJKBgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbXJKBgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 21:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbXJKBgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 21:36:12 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:35553 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803AbXJKBgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 21:36:12 -0400
Message-ID: <470D7E08.10209@davidnewall.com>
Date: Thu, 11 Oct 2007 11:06:08 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Russ Dill <russ.dill@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [OT] Argument with an OS professor over profile=3
References: <f9d2a5e10710101708l707eb619l6446f2e648ee016e@mail.gmail.com>
In-Reply-To: <f9d2a5e10710101708l707eb619l6446f2e648ee016e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russ Dill wrote:
> I've been having a back and forth going for a while with my TA and OS
> professor on the meaning of profile=3 and have been unable to convince
> either of them. The basic question is if profile=3 is passed to kernel
> with an 8MB text section, how big is the allocated profile buffer. His
> answer is 1MB....
>
>         if (prof_shift) {
>                 unsigned int size;
>                 /* only text is profiled */
>                 prof_len = (unsigned *) &_etext - (unsigned *) &_stext;
>   
You stipulated 8MB text, but this calculates in unsigned ints, so 
prof_len = 2M.

>                 prof_len >>= prof_shift;
>   

This gives 250K (divide by 8).

>                 size = prof_len * sizeof(unsigned int) + PAGE_SIZE-1;
>   

Finally, size is 1MB (250K x 4).

>                 prof_buffer = (unsigned int *) alloc_bootmem(size);
>         }
>   

I'm with your Prof.  Perhaps you missed that prof_len counts integers, 
not bytes.
