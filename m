Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbZEKJhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbZEKJhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755575AbZEKJhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:37:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59248 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521AbZEKJha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:37:30 -0400
Date: Mon, 11 May 2009 11:36:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: Sanity check the e820 against the SRAT table
	using e820 map only
Message-ID: <20090511093612.GD26444@elte.hu>
References: <4A01C08F.8020607@kernel.org> <20090507134723.GA32409@csn.ul.ie> <20090507142121.GL481@elte.hu> <4A03E10C.60906@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A03E10C.60906@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0014]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> -	e820ram = max_pfn - absent_pages_in_range(0, max_pfn);
> +	e820ram = max_pfn - (e820_hole_size(0, max_pfn<<PAGE_SHIFT)>>PAGE_SHIFT);

btw., it would be nice to have a debug check that prints a warning 
if the SRAT does not cover all RAM, or if it covers RAM that is not 
present in the e820 map. Such a warning might alert us to double 
check all the PXM settings in the SRAT and could uncover more quirks 
like the above ...

	Ingo
