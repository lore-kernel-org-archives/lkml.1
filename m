Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbYGKAUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbYGKAUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 20:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbYGKAUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:20:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754844AbYGKAUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:20:40 -0400
Date: Thu, 10 Jul 2008 17:14:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com,
       andi@firstfloor.org, ebiederm@xmission.com, jbarnes@virtuousgeek.org,
       steiner@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 21/26] x64, x2apic/intr-remap: setup init_apic_ldr for
 UV
Message-Id: <20080710171430.b15306a3.akpm@linux-foundation.org>
In-Reply-To: <20080710182238.916522000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
	<20080710182238.916522000@linux-os.sc.intel.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 11:16:55 -0700 Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> +static inline void uv_init_apic_ldr(void)
> +{
> +}
> +
>  static unsigned int uv_cpu_mask_to_apicid(cpumask_t cpumask)
>  {
>  	int cpu;
> @@ -164,6 +168,7 @@
>  	.target_cpus = uv_target_cpus,
>  	.vector_allocation_domain = uv_vector_allocation_domain,/* Fixme ZZZ */
>  	.apic_id_registered = uv_apic_id_registered,
> +	.init_apic_ldr = uv_init_apic_ldr,

There's no point in declaring it inline if it's always called indirectly.
