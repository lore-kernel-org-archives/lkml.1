Return-Path: <linux-kernel-owner+w=401wt.eu-S933860AbYAaNBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860AbYAaNBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764439AbYAaNBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:01:11 -0500
Received: from www.tglx.de ([62.245.132.106]:40987 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758631AbYAaNBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:01:10 -0500
Date: Thu, 31 Jan 2008 14:00:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Huang, Ying" <ying.huang@intel.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86: add executable mapping support to ioremap
In-Reply-To: <1201764967.12950.25.camel@caritas-dev.intel.com>
Message-ID: <alpine.LFD.1.00.0801311324270.9204@apollo.tec.linutronix.de>
References: <1201764967.12950.25.camel@caritas-dev.intel.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Huang, Ying wrote:

> This patch makes ioremap() can be used to map pages as executable,
> this is needed by EFI support.

> +extern void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
> +			       enum ioremap_mode mode,
> +			       enum ioremap_xmode xmode);
> +

Why do you want to add a new API?

    addr = ioremap(phys_addr, len);
    set_memory_x(addr);

should do what you want already. I think Arjan was not very clear in
his reply yesterday.

We tried to avoid the intermingling of ioremap and the page attribute
settings. We just kept the cached/uncached part.

Now thinking about it further, we should probably fully decouple the
mapping and the attribute change and remove the enum argument from
__ioremap and change the implementations of ioremap_cached and
ioremap_uncached to do the attribute setting after the remap. 

That way ioremap_chached and ioremap_uncached just would become what
they should be: conveniance functions for the developers.

Thanks,
	tglx
