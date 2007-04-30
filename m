Return-Path: <linux-kernel-owner+w=401wt.eu-S1031555AbXD3Rli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031555AbXD3Rli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946522AbXD3Rli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:41:38 -0400
Received: from holomorphy.com ([66.93.40.71]:56400 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031555AbXD3Rlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:41:36 -0400
Date: Mon, 30 Apr 2007 10:38:19 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [-mm patch] i386: enable 4k stacks by default
Message-ID: <20070430173819.GC19966@holomorphy.com>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73slaiys9v.fsf@bingen.suse.de>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 02:13:16PM +0200, Andi Kleen wrote:
> Actually looking at the code it would need some fixes first:
> /*
>  * These should really be __section__(".bss.page_aligned") as well, but
>  * gcc's 3.0 and earlier don't handle that correctly.
>  */
> static char softirq_stack[NR_CPUS * THREAD_SIZE]
>                 __attribute__((__aligned__(THREAD_SIZE)));
> 
> static char hardirq_stack[NR_CPUS * THREAD_SIZE]
>                 __attribute__((__aligned__(THREAD_SIZE)));
> 
> With 8K stacks and NR_CPUS==128 that would be 2MB statically reserved. Yuck.
> Really needs to be dynamically allocated. I'll take a look once the .22 
> big merge is done.

Here's what I did for i386 for someone concerned about blowing the stack.


-- wli
