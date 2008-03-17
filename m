Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbYCQU5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbYCQU5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbYCQU5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:57:41 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:6897 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbYCQU5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:57:41 -0400
Message-ID: <47DEDB3F.3040500@hp.com>
Date: Mon, 17 Mar 2008 16:57:35 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, dgc@sgi.com
Subject: Re: [PATCH (block.git) 0/2] IO CPU affinity update:
References: <47DE9D8F.8050402@hp.com> <20080317192714.GJ17940@kernel.dk>
In-Reply-To: <20080317192714.GJ17940@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Mon, Mar 17 2008, Alan D. Brunelle wrote:
>> Hi Jens -
>>
>> Two patches: 
>>
>> 1. Adds in the IRQ saving to generic_smp_call_function_single_interrupt (as you had suggested).
>> 2. Ensures a single IPI generated to get a remote function call handler going. 
>>
>> So far it is working better than before on the 4-way IA64 w/ the mkfs/untar/make test suite - after 22 runs:
>>
>> Part  RQ   MIN     AVG     MAX      Dev
>> ----- --  ------  ------  ------  ------
>>  mkfs  0  18.786  19.253  19.655   0.241
>>  mkfs  1  18.639  19.182  19.786   0.293
>>
>> untar  0  17.140  17.486  18.250   0.322
>> untar  1  16.951  17.494  18.274   0.350
>>
>>  make  0  22.927  24.310  34.339   2.287
>>  make  1  22.863  23.788  24.189   0.333
>>
>>  comb  0  59.478  61.049  70.320   2.142
>>  comb  1  59.875  60.463  61.305   0.458
>>
>>  psys  0   3.96%   4.14%   4.39%   0.100
>>  psys  1   3.60%   3.85%   4.19%   0.176
>>
>> So we're seeing reduced time (~1.0%) and reduced %sys to do it (7.0%).
>> The tighter deviations for make with rq=1 may be interesting... :-)
>>
>> I've compiled & booted the patches for x86_64 - rq=1 is working on
>> that platform too.
> 
> This is starting to look pretty good! Thanks a lot for these results,
> and the ->activated optimizations. I had a feeling the unstable results
> were something like this, missing ipi's.
> 

Jens: FYI: I am still seeing infrequent hangs on the x86_64-based platform. It happened again today after my patch was added, I did get <alt><sysrq><W> to work this time, and the threads that were stuck were waiting for IOs to complete. I believe at some point you were thinking of hacking in a block IO dump magic key as well - is that there yet?

I'll get to the ia64 testing tomorrow - have to run now, spent most of the day looking at what could cause stuff to be missed on x86_64. The code looks solid to me, but this hang needs to be figured out. 

Lastly, I did do a run on a 16-way ia64 (with my patches) and again it ran fine.

Alan
