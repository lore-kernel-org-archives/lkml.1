Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbYCPSOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbYCPSOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 14:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYCPSOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 14:14:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:47497 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYCPSOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 14:14:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=UJYxGrtTMDV+5E4Yj2wR32uLxlW5uiw98lJZkuqgBC9h0OK6dZNxDIG7vT4QAMLOqUif0eeFO5HL7nJl31fikloXYGXPyr3ewoS0z4hw6sQkgG6dPp4u1HXqomo9Cld8wcu73w+qjNR9tI1MKA7Jcn9NdhWIcnmJAy6/Hqp20nM=
Message-ID: <47DD6356.30906@gmail.com>
Date: Sun, 16 Mar 2008 13:13:42 -0500
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Allan Menezes <amenezes007@sympatico.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: HPL benchmarking linux kernel for shared memory performance.
References: <47DCB26B.20907@sympatico.ca>
In-Reply-To: <47DCB26B.20907@sympatico.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allan Menezes wrote:
> Hi,
>    I eliminated in which kernel verion this begins to happen. I am 
> benchmarking a single node with hpl and openmpi beta 1.3 and gotoblas v1.24
> for personal noncommercial reasons.
> I tried a single node with the command $ mpirun -np 1 ./xhpl
> and with kernel ver 2.6.23.14 i get over 38Gflops
> but with kernel ver 2.6.23.15 compiling with the same .config i get 7.xx 
> Gflops which is 1/5th that of the other kernel.
> Keep in mind that only the kernels have changed from kernel.org not any 
> hardware or anything else as all else is same! but the  performace drops 
> to 1/5th
> There is no network involved in this single node quad core intel test 
> but just shared memory.
> So the shared memory or smp performance of the newer kernels is far far 
> worse than upto 2.6.23.14!
> Even with 2.6.25.rc5 the performance is degraded!
> Can you please help me find why this is occurring? Please advise!
> mY set up Quad core Q6600 intel overclocked stably to 2.88 GHZ , 6 gig 
> ddr2 800 mhz dual channel ram,
> Allan Menezes

Make sure that it is actually using multiple processes or threads, if it was 
only using a single thread the number could be that low, and a number of really 
trivial things being wrong could cause it to only be using one thread.  "top -H" 
will show threads.

Is the HPL executable identical (the same executable should work just fine so 
long as the underlying HW is the same, so no need to recompile/relink xhpl)?

And you might also try Intel's MKL with hpl and see if that is better or worse 
than gotoblas (this probably won't affect the problem, but it would be good to 
know if the Intel MKL is better or worse than gotoblas).

Also, as the other person mentioned use git bisect and figure out which patch 
did it, if you can identify one patch someone can probably figure it out.

                            Roger
