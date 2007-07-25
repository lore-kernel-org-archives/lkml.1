Return-Path: <linux-kernel-owner+w=401wt.eu-S1765435AbXGYXXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765435AbXGYXXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 19:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760035AbXGYXW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 19:22:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:57862 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034AbXGYXW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 19:22:58 -0400
Subject: Re: pte_offset_map for ppc assumes HIGHPTE
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andreas Schwab <schwab@suse.de>
Cc: Satya <satyakiran@gmail.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <jewswodqcn.fsf@sykes.suse.de>
References: <acbcf3840707251516w301f834cj5f6a81a494d359ed@mail.gmail.com>
	 <jewswodqcn.fsf@sykes.suse.de>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 09:22:45 +1000
Message-Id: <1185405765.5439.371.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 01:18 +0200, Andreas Schwab wrote:
> Satya <satyakiran@gmail.com> writes:
> 
> > hello,
> > The implementation of pte_offset_map() for ppc assumes that PTEs are
> > kept in highmem (CONFIG_HIGHPTE). There is only one implmentation of
> > pte_offset_map() as follows (include/asm-ppc/pgtable.h):
> >
> > #define pte_offset_map(dir, addr)               \
> >          ((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE0) + pte_index(addr))
> >
> > Shouldn't this be made conditional according to CONFIG_HIGHPTE is
> > defined or not
> 
> kmap_atomic is always defined with or without CONFIG_HIGHPTE.
> 
> > (as implemented in include/asm-i386/pgtable.h) ?
> 
> I don't think that needs it either.

Depends... if you have CONFIG_HIGHMEM and not CONFIG_HIGHPTE, you are wasting
time going through kmap_atomic unnecessarily no ? it will probably not do anything
because the PTE page is in lowmem but still...

Ben.

