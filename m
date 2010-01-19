Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259Ab0ASL3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab0ASL3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 06:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876Ab0ASL3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 06:29:46 -0500
Received: from mga10.intel.com ([192.55.52.92]:5519 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755826Ab0ASL3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 06:29:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,300,1262592000"; 
   d="scan'208";a="765423061"
Message-ID: <4B5597A7.4080607@linux.intel.com>
Date: Tue, 19 Jan 2010 19:29:43 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm/srat_64.c: nodes_parsed should include all nodes
 detected by ACPI.
References: <4B501C4D.4080907@linux.intel.com> <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com> <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com> <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com> <4B5592B1.9030800@linux.intel.com>
In-Reply-To: <4B5592B1.9030800@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haicheng Li wrote:
> - it recovers node with oldnode as long as current entry is 
> HOT_PLUGGABLE. so it handles the recover issue. but I think following 
> patch can simply fix it as well.
> 
> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
> index dbb5381..fdf067f 100644
> --- a/arch/x86/mm/srat_64.c
> +++ b/arch/x86/mm/srat_64.c
> @@ -281,7 +281,7 @@ acpi_numa_memory_affinity_init(struct 
> acpi_srat_mem_affinity *ma)
>      if (!node_test_and_set(node, nodes_parsed)) {
>          nd->start = start;
>          nd->end = end;
> -    } else {
> +    } else if ((nd->start | nd->end) != 0) {
oops, typo here, should be:
+    } else if ((start | end) != 0) {

>          if (start < nd->start)
>              nd->start = start;
>          if (nd->end < end)
> 

