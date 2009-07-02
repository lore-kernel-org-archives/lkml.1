Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbZGBI2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbZGBI2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 04:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZGBI1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 04:27:47 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:51055 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbZGBI1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 04:27:46 -0400
Date: Thu, 2 Jul 2009 09:26:54 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kevin Cernekee <cernekee@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix virt_to_phys() warnings
Message-ID: <20090702082654.GA14804@linux-mips.org>
References: <910ba280decc9ee53d9971ba04f73fab@localhost> <20090701224627.0b2704df.akpm@linux-foundation.org> <87bpo3bm0t.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bpo3bm0t.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 09:07:46AM +0200, Andi Kleen wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Date: Thu, 02 Jul 2009 09:07:46 +0200
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kevin Cernekee <cernekee@gmail.com>, linux-kernel@vger.kernel.org,
> 	Ralf Baechle <ralf@linux-mips.org>
> Subject: Re: [PATCH] Fix virt_to_phys() warnings
> Content-Type: text/plain; charset=us-ascii
> 
> Andrew Morton <akpm@linux-foundation.org> writes:
> >
> > #define virt_to_page(kaddr)        pfn_to_page(PFN_DOWN(virt_to_phys(kaddr)))
> >
> > thereby passing an `unsigned long' where a void* was expected.
> >
> >
> > So perhaps something along these lines:
> 
> I'm not quite sure it's the case on MIPS, but I remember on x86 one of
> the reasons this was done as a macro was to avoid a include dependency
> loop with struct page.

The MIPS <asm/page.h> uses a forward declaration for the same reason since
a very long time.  These days struct page is defined in <linux/mm_types.h>
but that file needs pgprot_t (which is defined in <asm/page.h> ...) to be
defined first so can't be included from the to of page.h.

  Ralf
