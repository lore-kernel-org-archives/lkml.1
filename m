Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbYBESqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbYBESqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbYBESqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:46:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59226 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451AbYBESq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:46:29 -0500
Date: Tue, 5 Feb 2008 10:46:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: schwidefsky@de.ibm.com
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/3] CONFIG_HIGHPTE vs. sub-page page tables.
Message-Id: <20080205104625.60fa86b0.akpm@linux-foundation.org>
In-Reply-To: <1202222388.25021.20.camel@localhost>
References: <20071112143009.425807965@de.ibm.com>
	<20071112144009.831296895@de.ibm.com>
	<20080201151541.8e3e0359.akpm@linux-foundation.org>
	<1202017020.7208.2.camel@pasglop>
	<20080202215315.3ac6907d.akpm@linux-foundation.org>
	<1202121409.31801.7.camel@localhost>
	<20080204025133.511ac3e2.akpm@linux-foundation.org>
	<1202222388.25021.20.camel@localhost>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Feb 2008 15:39:47 +0100 Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Mon, 2008-02-04 at 02:51 -0800, Andrew Morton wrote:
> > > > Look: I can't fix *everyone's* stuff.  This was a consequence of ongoing
> > > > unbounded churn in the x86 tree.  If we can find a way of preventing those
> > > > guys (and everyone else) from trashing everyone else's stuff then we'd have
> > > > much smoother sailing.
> > > 
> > > Understood. That is where I jump in and regenerate my patches on the
> > > latest available level. That the patches did hold up for some months in
> > > -mm now without really breaking anything is an indication that we can
> > > push them upstream now, isn't ? That would make the patch problem go
> > > away and I could queue my s390 specific page table rework. Our KVM
> > > people keep asking about it.
> > 
> > yes, against 2.6.24-mm1 would be good, thanks.  I really don't know what
> > went wrong in i386 but I ended up getting all grumpy at the macro mess
> > we've made in all the pagetable handling.  Please do take a look at
> > improving that.
> 
> I'm trying to replace the __pte_free_tlb macros my patch touches for the
> different architectures. Not much luck yet, there is a reason why
> __pte_free_tlb is a macro in the first place: welcome to #include hell.
> I'm starting to get grumpy as well..
> 
> Just an example for x86-64:
> * asm-x86/tlb.h includes asm-generic/tlb.h
> * asm-generic/tlb.h includes asm-x86/pgalloc.h
> * asm-x86/pgalloc.h includes asm-x86/pgalloc_64.h
> * asm-x86/pgalloc_64.h includes asm-x86/tlb.h
> * since asm-x86/tlb.h started this #include chain it expands to nothing
> * asm-x86/pgalloc_64.h calls tlb_remove_page which is defined in
>   asm-x86/tlb.h but the compiler hasn't seen the definition yet
> * you loose..
> 
> I got x86-64 compiled by removing the #include <asm/pgalloc.h> from
> asm-generic/tlb.h. But who knows what will break if the include is
> missing .. I'll cross compile some of the other architectures next.
> 

urgh, well, thanks for trying.  If there's significant risk factor (or
hassle) in fixing the macros then I'd suggest we not do it for now - it's a
separate project.

At least x86 is getting better in that regard.
