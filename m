Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbYISIca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbYISIca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 04:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbYISIcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 04:32:22 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:36176 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYISIcV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 04:32:21 -0400
Message-Id: <48D37FDA.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 19 Sep 2008 09:32:58 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v3)
References: <48D21BA3.76E4.0078.0@novell.com>
 <20080918071852.GA7639@elte.hu> <20080918091003.GA3751@elte.hu>
 <48D23BF6.76E4.0078.0@novell.com> <20080918095710.GA11633@elte.hu>
 <20080918112018.GA456@elte.hu> <48D25E87.76E4.0078.0@novell.com>
 <48D29741.4070404@goop.org>
In-Reply-To: <48D29741.4070404@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 18.09.08 20:00 >>>
>I take it we're talking about this chunk:
>
>-static inline int phys_addr_valid(unsigned long addr)
>+static inline int phys_addr_valid(resource_size_t addr)
> {
>-	return addr < (1UL << boot_cpu_data.x86_phys_bits);
>+#ifdef CONFIG_RESOURCES_64BIT
>+	return !(addr >> boot_cpu_data.x86_phys_bits);
>+#else
>+	return 1;
>+#endif

Yes.

>Is x86_phys_bits defined to be the actual number of address lines poking
>out of the CPU package, or the number of address bits we can
>meaningfully put into a pte?

The intention is for it to express a CPU capability.

>I would say the simplest thing to do here is be explicit:
>
>	if (sizeof(addr) == sizeof(u64))
>		return !(addr >> boot_cpu_data.x86_phys_bits);
>	else
>		return 1; 
>
>That's not ideal, but I guess its good enough.  I assume x86_phys_bits
>can never be less than 32?

Yes, one could do it that way. But what's the point of having RESOURCES_64BIT
set and resource_size_t nevertheless being a 32-bit quantity? And why,
independent of that, was ioremap() not changed to use phys_addr_t?

Jan

