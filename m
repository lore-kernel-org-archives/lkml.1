Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbZEKPxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbZEKPxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbZEKPww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:52:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:51001 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbZEKPwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:52:50 -0400
Message-ID: <4A08497C.8010203@kernel.org>
Date: Mon, 11 May 2009 08:51:24 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: Sanity check the e820 against the SRAT table
 using e820 map only
References: <4A01C08F.8020607@kernel.org> <20090507134723.GA32409@csn.ul.ie> <20090507142121.GL481@elte.hu> <4A03E10C.60906@kernel.org> <20090511093612.GD26444@elte.hu>
In-Reply-To: <20090511093612.GD26444@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> -	e820ram = max_pfn - absent_pages_in_range(0, max_pfn);
>> +	e820ram = max_pfn - (e820_hole_size(0, max_pfn<<PAGE_SHIFT)>>PAGE_SHIFT);
> 
> btw., it would be nice to have a debug check that prints a warning 
> if the SRAT does not cover all RAM, or if it covers RAM that is not 
> present in the e820 map. Such a warning might alert us to double 
> check all the PXM settings in the SRAT and could uncover more quirks 
> like the above ...

we trust e820 than SRAT mem entries.

so early_node_map already are result of in e820 range AND srat.  (the range in SRAT that is not in e820 is dumped)

just check srat table (without AND) with e820 will have some confusing. because SRAT would cover the hole below 4g that is not in E820.

YH


