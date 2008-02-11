Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbYBKNz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbYBKNz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 08:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYBKNzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 08:55:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50555 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbYBKNzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 08:55:49 -0500
Date: Mon, 11 Feb 2008 14:55:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: ying.huang@intel.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [6/8] Account overlapped mappings in end_pfn_map
Message-ID: <20080211135535.GA14502@elte.hu>
References: <200802111034.764275766@suse.de> <20080211093434.E30961B41CE@basil.firstfloor.org> <20080211130843.GC23733@elte.hu> <200802111427.16288.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802111427.16288.ak@suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> > your patch is also a bit unclean:
> 
> Ok patch with hungarized variables appended.

My comments have nothing to do with "hungarized variables". You used 
clearly unclean and ambigious coding constructs like:

+static unsigned long __meminit
 phys_pmd_update(pud_t *pud, unsigned long address, unsigned long end)
 {
+       unsigned long r;
        pmd_t *pmd = pmd_offset(pud, 0);
        spin_lock(&init_mm.page_table_lock);
-       phys_pmd_init(pmd, address, end);
+       r = phys_pmd_init(pmd, address, end);
        spin_unlock(&init_mm.page_table_lock);
        __flush_tlb_all();
+       return r;
 }

the "r" name is totally unintuitive and the reader of the code is given 
absolutely no idea what happens here.

The cleanliness rules about descriptive variable names are obvious, 
necessary and well respected throughout the kernel, by all other kernel 
contributors i know. For years you were allowed to merge such patches. 
You should really (re-)learn and accept the rules that all other kernel 
contributors have been following for years.

	Ingo
