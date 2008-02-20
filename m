Return-Path: <linux-kernel-owner+w=401wt.eu-S1764952AbYBTNAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764952AbYBTNAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 08:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762930AbYBTM41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 07:56:27 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:53712 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762661AbYBTM40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 07:56:26 -0500
Message-ID: <47BC2275.4060900@linux.vnet.ibm.com>
Date: Wed, 20 Feb 2008 18:22:05 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller
 in Kconfig
References: <20080220122338.GA4352@basil.nowhere.org>
In-Reply-To: <20080220122338.GA4352@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Document huge memory/cache overhead of memory controller in Kconfig
> 
> I was a little surprised that 2.6.25-rc* increased struct page for the memory
> controller.  At least on many x86-64 machines it will not fit into a single
> cache line now anymore and also costs considerable amounts of RAM. 

The size of struct page earlier was 56 bytes on x86_64 and with 64 bytes it
won't fit into the cacheline anymore? Please also look at
http://lwn.net/Articles/234974/

> At earlier review I remembered asking for a external data structure for this.
> 
> It's also quite unobvious that a innocent looking Kconfig option with a 
> single line Kconfig description has such a negative effect.
> 
> This patch attempts to document these disadvantages at least so that users
> configuring their kernel can make a informed decision.
> 
> Cc: balbir@linux.vnet.ibm.com
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> Index: linux/init/Kconfig
> ===================================================================
> --- linux.orig/init/Kconfig
> +++ linux/init/Kconfig
> @@ -394,6 +394,14 @@ config CGROUP_MEM_CONT
>  	  Provides a memory controller that manages both page cache and
>  	  RSS memory.
> 
> +	  Note that setting this option increases fixed memory overhead
> +	  associated with each page of memory in the system by 4/8 bytes
> +	  and also increases cache misses because struct page on many 64bit
> +	  systems will not fit into a single cache line anymore.
> +
> +	  Only enable when you're ok with these trade offs and really
> +	  sure you need the memory controller.
> +

Looks good

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

>  config PROC_PID_CPUSET
>  	bool "Include legacy /proc/<pid>/cpuset file"
>  	depends on CPUSETS


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
