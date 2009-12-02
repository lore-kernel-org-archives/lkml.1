Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbZLBQjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbZLBQjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 11:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbZLBQjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 11:39:12 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:22890 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbZLBQjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 11:39:12 -0500
Message-ID: <4B1697ED.1050602@oracle.com>
Date: Wed, 02 Dec 2009 08:38:05 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] percpu: add missing per_cpu_ptr_to_phys() definition
 for UP
References: <4B1560C2.8040603@oracle.com> <4B15A9EA.3090108@kernel.org>
In-Reply-To: <4B15A9EA.3090108@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B1697F9.0038:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Commit 3b034b0d084221596bf35c8d893e1d4d5477b9cc implemented
> per_cpu_ptr_to_phys() but forgot to add UP definition.  Add UP
> definition which is simple wrapper around __pa().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>

Yes, that builds now.  Thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
> Hello,
> 
>> drivers/base/cpu.c: line 100: fails to build when CONFIG_SMP=n:
>>
>> 	addr = per_cpu_ptr_to_phys(per_cpu_ptr(crash_notes, cpunum));
>>
>> Can you suggest a fix for that, please?
> 
> Oops, right, UP definition was missing.  This patch should do it.
> 
> Thanks.
> 
>  include/linux/percpu.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> index 6ac984f..8e4ead6 100644
> --- a/include/linux/percpu.h
> +++ b/include/linux/percpu.h
> @@ -180,6 +180,11 @@ static inline void free_percpu(void *p)
>  	kfree(p);
>  }
>  
> +static inline phys_addr_t per_cpu_ptr_to_phys(void *addr)
> +{
> +	return __pa(addr);
> +}
> +
>  static inline void __init setup_per_cpu_areas(void) { }
>  
>  static inline void *pcpu_lpage_remapped(void *kaddr)


-- 
~Randy
