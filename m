Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbZF3WDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbZF3WDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZF3WD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:03:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42856 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbZF3WD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:03:27 -0400
Date: Wed, 1 Jul 2009 00:03:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: bernhard.walle@gmx.de, Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] don't use alloc_bootmem_low() where not strictly needed
Message-ID: <20090630220318.GC1241@elte.hu>
References: <4A4A111A020000780000831A@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4A111A020000780000831A@vpn.id2.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> Since alloc_bootmem() will never return inaccessible (via virtual 
> addressing) memory anyway, using the ..._low() variant only makes 
> sense when the physical address range of the allocated memory must 
> fulfill further constraints, espacially since on 64-bits (or more 
> generally in all cases where the pools the two variants allocate 
> from are different), the space available for ..._low() is more 
> easily exhausted than the full available range.

hm, i have some vague memories of the _low() being relevant for 
things like PAGEALLOC stability. Thomas, do you remember anything 
specific there?

	Ingo
