Return-Path: <linux-kernel-owner+w=401wt.eu-S1764552AbZDILro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764552AbZDILro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 07:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759579AbZDILre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 07:47:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:54206 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758776AbZDILrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 07:47:33 -0400
Message-ID: <49DDE07C.8050101@kernel.org>
Date: Thu, 09 Apr 2009 04:48:12 -0700
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12]: sparc64: Use new dynamic per-cpu allocator.
References: <20090408.223758.81953207.davem@davemloft.net>
In-Reply-To: <20090408.223758.81953207.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 11:47:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The percpu part looks good to me.  Just one question below.

David Miller wrote:
>  void __init setup_per_cpu_areas(void)
>  {
> -	unsigned long size, i, nr_possible_cpus = num_possible_cpus();
> -	char *ptr;
> +	size_t dyn_size, static_size = __per_cpu_end - __per_cpu_start;
> +	static struct vm_struct vm;
> +	unsigned long delta, cpu;
> +	size_t pcpu_unit_size;
> +	size_t ptrs_size;
> +
> +	pcpur_size = PFN_ALIGN(static_size + PERCPU_MODULE_RESERVE +
> +			       PERCPU_DYNAMIC_RESERVE);
> +	dyn_size = pcpur_size - static_size - PERCPU_MODULE_RESERVE;

Isn't it better to use embedding allocator for !NUMA cases (one less
TLB entry usage for each CPU)?

Thanks.

-- 
tejun
