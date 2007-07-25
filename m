Return-Path: <linux-kernel-owner+w=401wt.eu-S1763457AbXGYXKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763457AbXGYXKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 19:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759398AbXGYXKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 19:10:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:58723 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759021AbXGYXK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 19:10:29 -0400
Subject: Re: pte_offset_map for ppc assumes HIGHPTE
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Satya <satyakiran@gmail.com>
Cc: linuxppc-dev@ozlabs.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <acbcf3840707251516w301f834cj5f6a81a494d359ed@mail.gmail.com>
References: <acbcf3840707251516w301f834cj5f6a81a494d359ed@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 09:10:15 +1000
Message-Id: <1185405015.5439.369.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-25 at 17:16 -0500, Satya wrote:
> hello,
> The implementation of pte_offset_map() for ppc assumes that PTEs are
> kept in highmem (CONFIG_HIGHPTE). There is only one implmentation of
> pte_offset_map() as follows (include/asm-ppc/pgtable.h):
> 
> #define pte_offset_map(dir, addr)               \
>          ((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE0) + pte_index(addr))
> 
> Shouldn't this be made conditional according to CONFIG_HIGHPTE is
> defined or not (as implemented in include/asm-i386/pgtable.h) ?
> 
> the same goes for pte_offset_map_nested and the corresponding unmap functions.

Do we have CONFIG_HIGHMEM without CONFIG_HIGHPTE ? If yes, then indeed,
we should change that. Though I'm not sure I see the point of splitting
those 2 options.

Ben.
 

