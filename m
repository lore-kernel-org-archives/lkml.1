Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbYBKOQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbYBKOQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 09:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbYBKOQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 09:16:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36376 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbYBKOQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 09:16:50 -0500
Subject: Re: [PATCH] [6/8] Account overlapped mappings in end_pfn_map
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, ying.huang@intel.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <200802111427.16288.ak@suse.de>
References: <200802111034.764275766@suse.de>
	 <20080211093434.E30961B41CE@basil.firstfloor.org>
	 <20080211130843.GC23733@elte.hu>  <200802111427.16288.ak@suse.de>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 15:16:31 +0100
Message-Id: <1202739391.6247.13.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-11 at 14:27 +0100, Andi Kleen wrote:

> Ok patch with hungarized variables appended.

> -static void __meminit
> +static unsigned long __meminit
>  phys_pmd_update(pud_t *pud, unsigned long address, unsigned long end)
>  {
> +	unsigned long true_end;
>  	pmd_t *pmd = pmd_offset(pud, 0);
>  	spin_lock(&init_mm.page_table_lock);
> -	phys_pmd_init(pmd, address, end);
> +	true_end = phys_pmd_init(pmd, address, end);
>  	spin_unlock(&init_mm.page_table_lock);
>  	__flush_tlb_all();
> +	return true_end;
>  }

Just for the record, Hungarian notation would have it like:

  ulTrueEnd

http://en.wikipedia.org/wiki/Hungarian_notation

And the kernel doesn't do that, to wit (from Documentation/CodingStyle):

 Linus Torvalds (against systems Hungarian): Encoding the type of a
function into the name (so-called Hungarian notation) is brain damaged -
the compiler knows the types anyway and can check those, and it only
confuses the programmer.



