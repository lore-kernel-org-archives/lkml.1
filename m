Return-Path: <linux-kernel-owner+w=401wt.eu-S932343AbYBBKO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbYBBKO1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 05:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758259AbYBBKOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 05:14:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57497 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbYBBKOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 05:14:16 -0500
Date: Sat, 2 Feb 2008 11:13:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 6 of 7] x86: move pud/pgd functions into common
	asm/pgalloc.h
Message-ID: <20080202101356.GA19782@elte.hu>
References: <patchbomb.1201943112@localhost> <fe3ff49757e16a5b9290.1201943118@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe3ff49757e16a5b9290.1201943118@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Common definitions for 4-level pagetable functions.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> ---
>  arch/x86/mm/pgtable.c        |    7 ++++++
>  include/asm-x86/pgalloc.h    |   46 ++++++++++++++++++++++++++++++++++++------
>  include/asm-x86/pgalloc_32.h |   24 ---------------------
>  include/asm-x86/pgalloc_64.h |   32 -----------------------------
>  4 files changed, 47 insertions(+), 62 deletions(-)

random-qa found an early bootup hang on 32-bit (config attached).

i bisected it down to this patch of yours. It's a bit large so it's not 
obvious what is happening. Could you please keep patches that do 
functional changes smaller? It's not a problem if the non-functional or 
trivial restructuring patches are larger, but it's a killer for these 
functional ones. I've dropped this one for now, and all the dependent 
patches as well:

Subject: x86: move pud/pgd functions into common asm/pgalloc.h
Subject: x86: move all the pgd_list handling to one place
Subject: x86: rename paravirt_alloc_pt etc after the pagetable structure
Subject: x86: add pud_alloc for 4-level pagetables
Subject: x86/pgtable.h: demacro ptep_set_access_flags
Subject: x86/pgtable.h: demacro ptep_test_and_clear_young
Subject: x86/pgtable.h: demacro ptep_clear_flush_young

	Ingo
