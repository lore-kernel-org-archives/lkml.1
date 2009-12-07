Return-Path: <linux-kernel-owner+w=401wt.eu-S1752385AbZLGFid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbZLGFid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 00:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbZLGFib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 00:38:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43408 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbZLGFib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 00:38:31 -0500
Date: Mon, 7 Dec 2009 06:38:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Alex Chiang <achiang@hp.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Li, Haicheng" <haicheng.li@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC] print symbolic page flag names in bad_page()
Message-ID: <20091207053806.GA17052@elte.hu>
References: <20091204212606.29258.98531.stgit@bob.kio>
 <20091206034636.GA7109@localhost>
 <20091206230016.GA18989@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091206230016.GA18989@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > So how about this patch?
> 
> I like it. Decoding the flags by hand is always a very unpleasant 
> experience. Bonus: dump_page can be called from kgdb too.

Guys, please do more review:

> +void dump_page(struct page *page)
> +{
> +     char buf[1024];

NAK. This code causes a brutal, +1K kernel stack footprint spike that 
can crash a system _precisely_ when we are trying to dump a (presumably 
rare) condition.

> +EXPORT_SYMBOL(dump_page);

( Small detail: such exports are EXPORT_SYMBOL_GPL - we dont want random 
  external modules start using it. )

Thanks,

	Ingo
