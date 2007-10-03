Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbXJCLZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbXJCLZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 07:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbXJCLZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 07:25:31 -0400
Received: from ns2.suse.de ([195.135.220.15]:36043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbXJCLZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 07:25:30 -0400
Date: Wed, 3 Oct 2007 13:25:27 +0200
From: Nick Piggin <npiggin@suse.de>
To: Matt Mackall <mpm@selenic.com>
Cc: Hugh Dickins <hugh@veritas.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pgd_none_or_clear_bad strangeness?
Message-ID: <20071003112527.GA10437@wotan.suse.de>
References: <20071002222003.GL19691@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002222003.GL19691@waste.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 05:20:03PM -0500, Matt Mackall wrote:
> In lib/pagewalk.c, I've been using the various forms of
> {pgd,pud,pmd}_none_or_clear_bad while walking page tables as that
> seemed the canonical way to do things. Lately (eg with -rc7-mm1),
> these have been triggering messages like "bad pgd 0x01e3" and causing
> nasty double faults. It appears this is actually triggered at the pmd
> level (mm/memory.c:116), though it appears to produce the wrong
> message.
> 
> Has something changed here? I'm pretty sure this used to work! Is this
> not a kosher thing to do? Does it make any sense I'd repeatedly run
> into a bad pmd in the middle of bash's page table right after boot?
> The simple _none variant seems to work, but I worry that it's papering
> over a real problem.

No, I think that should be the right thing to do for userspace pages.
You're not walking into a hugetlb area or a kernel mapping are you?
(the bad pgd: line could be important... 0x01e3 would be a linear kernel
mapping I think?).

