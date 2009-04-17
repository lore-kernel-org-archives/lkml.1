Return-Path: <linux-kernel-owner+w=401wt.eu-S1762386AbZDQRqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762386AbZDQRqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759132AbZDQRqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:46:23 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46640 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630AbZDQRqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:46:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sGLj7eIEAWwsJvIORIB91veYGvNe1C6t3UmJKazzPTTghW5rzzS/hnxC4VgfIOo2Fo
         Ne0aYyFB3SjvrUbPJzYa3Xxf54VxSwtKfsbqWMNLj+yajTpKVO4pd3KdQTEczyPUYMEE
         /zxg7sX6WZhiiwHcf78uRiTDL5LgXk1ozV/gM=
Message-ID: <49E8C06A.5080605@tuffmail.co.uk>
Date: Fri, 17 Apr 2009 18:46:18 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13058] First hibernation attempt fails
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090417063007.GB4593@kernel.dk> <49E83DC4.8040207@tuffmail.co.uk> <20090417091321.GP4593@kernel.dk> <20090417093359.GQ4593@kernel.dk> <49E84DF8.7030802@tuffmail.co.uk> <20090417094558.GR4593@kernel.dk> <49E85DFD.9030306@tuffmail.co.uk> <alpine.LFD.2.00.0904170856460.4042@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904170856460.4042@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Fri, 17 Apr 2009, Alan Jenkins wrote:
>   
>> As another datapoint:  I tried blindly applying the commit to 2.6.29. 
>> The resulting kernel was able to hibernate fine the first time.
>>     
>
> Yeah, so it's not that commit per se that causes it. I bet it needs all 
> the IO scheduler changes too - and even when it does that, the end result 
> probably is really just a timing change.
>
>   
>> I'm going to be annoying and try something slightly different.  In
>> theory, I should be able to find the "first bad commit" where
>> cherry-picking 1faa16d22 causes a problem.
>>     
>
> Just for fun, try this one first and see if it makes any difference.
>
> Maybe the whole "swappiness=0" part was intentional. And maybe it wasn't. 
> This is one trivial patch. Maybe it makes your machine blow up. Who knows?
>
> There are other differences in the shrink_all_memory() path wrt the normal 
> memory freeing paths, but they are way more subtle. So I'm suggesting 
> tryign this not becasue I think it's "The Bug(tm)", but because it's an 
> easy test to make, and maybe it makes a difference.
>
> 		Linus
> ---
>  mm/vmscan.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 39fdfb1..d3595ed 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2113,6 +2113,8 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
>  	struct scan_control sc = {
>  		.gfp_mask = GFP_KERNEL,
>  		.may_unmap = 0,
> +		.swap_cluster_max = SWAP_CLUSTER_MAX,
> +		.swappiness = vm_swappiness,
>  		.may_writepage = 1,
>  		.isolate_pages = isolate_pages_global,
>  	};
>   


No, that doesn't seem to affect it.

Thanks
Alan
