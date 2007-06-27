Return-Path: <linux-kernel-owner+w=401wt.eu-S1761787AbXF0RHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761787AbXF0RHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbXF0RHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:07:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:57118 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbXF0RHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:07:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,467,1175497200"; 
   d="scan'208";a="244017144"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Wed, 27 Jun 2007 10:06:16 -0700
User-Agent: KMail/1.9.7
Cc: Mauro Giachero <mauro.giachero@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <200706251434.43863.jesse.barnes@intel.com> <200706270922.05801.jesse.barnes@intel.com> <4682982B.8060200@macroscoop.nl>
In-Reply-To: <4682982B.8060200@macroscoop.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706271006.16956.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 27, 2007 10:02:35 Pim Zandbergen wrote:
> Jesse Barnes wrote:
> > It looks like end_pfn might be ~0UL now... can you print that out
> > in your configuration?
>
> Er, do you need the value of end_pfn ?
> Here's what I changed:
>
> if ((highest_addr >> PAGE_SHIFT) != end_pfn) {
>          printk(KERN_WARNING "***************\n");
>          printk(KERN_WARNING "**** WARNING: likely BIOS bug\n");
>          printk(KERN_WARNING "**** MTRRs don't cover all of "
>                 "memory, trimmed %lu pages\n", end_pfn -
>                 (highest_addr >> PAGE_SHIFT));
>          printk(KERN_WARNING "**** end_pfn before = %lu\n", end_pfn);
>          end_pfn = highest_addr >> PAGE_SHIFT;
>          printk(KERN_WARNING "**** end_pfn after = %lu\n", end_pfn);
>          printk(KERN_WARNING "***************\n");
> }
>
> Here's the result:
> ***************
> **** WARNING: likely BIOS bug
> **** MTRRs don't cover all of memory, trimmed 18446744073709486080
> pages **** end_pfn before = 2293760
> **** end_pfn after = 2359296
> ***************
>
> Hope that's what you needed.

Yeah, that's what I needed.  end_pfn looks ok, but I guess my test is a 
little too precise.  It should be if ((highest_addr >> PAGE_SHIFT) < 
end_pfn) rather than !=.  That should keep it from trying to extend 
your memory with bogus math.  I thought that the two values should 
always match, but I guess slightly different memory configurations 
might break that assumption.

Thanks,
Jesse
