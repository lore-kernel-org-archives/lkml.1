Return-Path: <linux-kernel-owner+w=401wt.eu-S1767449AbXCISKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767449AbXCISKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 13:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767451AbXCISKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 13:10:15 -0500
Received: from mtaout5.012.net.il ([84.95.2.13]:19979 "EHLO mtaout5.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767449AbXCISKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 13:10:13 -0500
Date: Fri, 09 Mar 2007 20:10:03 +0200
From: Avi Kivity <avi@argo.co.il>
Subject: Re: [PATCH 4/4 TRY#3] optimize and simplify get_cycles_sync()
In-reply-to: <20070309151511.GE13481@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: discuss@x86-64.org, Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Message-id: <45F1A2FB.7040206@argo.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Fri,
 09 Mar 2007 20:10:03 +0200 (IST)
References: <20070309150825.GA13481@amd.com> <20070309151511.GE13481@amd.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> From: Joerg Roedel <joerg.roedel@amd.com>
>
> This patch simplifies the get_cycles_sync() function by removing
> the #ifdefs from it. Further it introduces an optimization for AMD
> processors. There the RDTSCP instruction is used instead of CPUID;RDTSC
> which is helpfull if the kernel runs as a KVM guest. Running as a guest
> makes CPUID very expensive because it causes an intercept of the guest.
>
>   
> +#define RDTSCP ".byte 0x0f, 0x01, 0xf9"
> +	alternative_io_two("cpuid\nrdtsc",
> +			   "rdtsc", X86_FEATURE_SYNC_RDTSC,
> +			   ".byte 0x0f, 0x01, 0xf9", X86_FEATURE_RDTSCP,
>   

why not use the RDTSCP macro here?


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

