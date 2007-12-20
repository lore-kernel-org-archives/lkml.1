Return-Path: <linux-kernel-owner+w=401wt.eu-S1760750AbXLTMoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760750AbXLTMoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbXLTMoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:44:21 -0500
Received: from elvis.franken.de ([193.175.24.41]:51512 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbXLTMoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:44:21 -0500
Date: Thu, 20 Dec 2007 13:43:51 +0100
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, Bob Picco <bob.picco@hp.com>,
       Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>,
       Andi Kleen <ak@muc.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Keith Mannthey <kmannth@gmail.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@osdl.org>, ralf@linux-mips.org
Subject: Re: [PATCH] Fix crash with FLAT_MEMORY and ARCH_PFN_OFFSET != 0
Message-ID: <20071220124351.GA8880@alpha.franken.de>
References: <20071218120300.7565AE3030@solo.franken.de> <20071218135828.GB24917@csn.ul.ie> <20071218160938.GA20688@alpha.franken.de> <20071220114405.GA9623@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220114405.GA9623@csn.ul.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 11:44:06AM +0000, Mel Gorman wrote:
> --- a/include/asm-mips/page.h
> +++ b/include/asm-mips/page.h
> @@ -37,13 +37,6 @@
>  #include <linux/pfn.h>
>  #include <asm/io.h>
>  
> -/*
> - * It's normally defined only for FLATMEM config but it's
> - * used in our early mem init code for all memory models.
> - * So always define it.
> - */
> -#define ARCH_PFN_OFFSET		PFN_UP(PHYS_OFFSET)
> -

hmm, doesn't this break what I've fixed ? Without this #define
ARCH_PFN_OFFSET gets defined to 0 and the bug is back. Or did
I miss anything ?

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
