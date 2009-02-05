Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbZBESop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbZBESop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbZBESof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:44:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59185 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbZBESof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:44:35 -0500
Date: Thu, 5 Feb 2009 19:43:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: pud_bad vs pud_bad
Message-ID: <20090205184355.GF5661@elte.hu>
References: <498B2EBC.60700@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B2EBC.60700@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> I'm looking at unifying the 32 and 64-bit versions of pud_bad.
>
> 32-bits defines it as:
>
> static inline int pud_bad(pud_t pud)
> {
> 	return (pud_val(pud) & ~(PTE_PFN_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
> }
>
> and 64 as:
>
> static inline int pud_bad(pud_t pud)
> {
> 	return (pud_val(pud) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
> }
>
>
> I'm inclined to go with the 64-bit version, but I'm wondering if there's 
> something subtle I'm missing here.

Why go with the 64-bit version? The 32-bit check looks more compact and 
should result in smaller code.

	Ingo
