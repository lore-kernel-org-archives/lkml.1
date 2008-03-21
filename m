Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbYCURqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbYCURqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757251AbYCURqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:46:16 -0400
Received: from www.tglx.de ([62.245.132.106]:48676 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbYCURqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:46:15 -0400
Date: Fri, 21 Mar 2008 18:45:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: andreas.herrmann3@amd.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/7] Don't use large pages to map the first 2/4MB of
 memory
In-Reply-To: <20080312025330.AC1961B41D1@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0803211843120.3781@apollo.tec.linutronix.de>
References: <20080312353.598285931@firstfloor.org> <20080312025330.AC1961B41D1@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Andi Kleen wrote:
> Intel recommends to not use large pages for the first 1MB 
> of the physical memory because there are fixed size MTRRs there
> which cause splitups in the TLBs.
> 
> On AMD doing so is also a good idea.
> 
> The implementation is a little different between 32bit and 64bit.
> On 32bit I just taught the initial page table set up about this
> because it was very simple to do. This also has the advantage
> that the risk of a prefetch ever seeing the page even
> if it only exists for a short time is minimized.
> 
> On 64bit that is not quite possible, so use set_memory_4k() a little
> later (in check_bugs) instead.


> +	/*
> +	 * Make sure the first 2MB area is not mapped by huge pages
> +	 * There are typically fixed size MTRRs in there and overlapping
> +	 * MTRRs into large pages causes slow downs.
> +	 *
> +	 * Right now we don't do that with gbpages because there seems
> +	 * very little benefit for that case.

And why exactly ? Does slowdown not matter with gbpages ? 

Also we split the first GB mapping anyway due to the various regions
(NX, RO, UC) in there.

Thanks,

	tglx
