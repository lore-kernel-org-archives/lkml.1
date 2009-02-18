Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZBRAsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZBRAsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbZBRAsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:48:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56603 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZBRAsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:48:15 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator (try 2)
Cc: kosaki.motohiro@jp.fujitsu.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <alpine.DEB.1.10.0902171504090.24395@qirst.com>
References: <84144f020902171143i5844ef83h20cb4bee4f65c904@mail.gmail.com> <alpine.DEB.1.10.0902171504090.24395@qirst.com>
Message-Id: <20090218093858.8990.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 18 Feb 2009 09:48:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 17 Feb 2009, Pekka Enberg wrote:
> 
> > >> +#define SLUB_MAX_SIZE (2 * PAGE_SIZE)
> >
> > On Tue, Feb 17, 2009 at 8:11 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > This relies on PAGE_SIZE being 4k.  If you want 8k, why don't you say
> > > so?  Pekka did this explicitely.
> >
> > That could be a problem, sure. Especially for architecture that have 64 K pages.
> 
> You could likely put a complicated formula in there instead. But 2 *
> PAGE_SIZE is simple and will work on all platforms regardless of pagesize.

I think 2 * PAGE_SIZE is best and the patch description is needed change.
it's because almost architecture use two pages for stack and current page
allocator don't have delayed consolidation mechanism for order-1 page.

In addition, if pekka patch (SLAB_LIMIT = 8K) run on ia64, 16K allocation 
always fallback to page allocator and using 64K (4 times memory consumption!).

Am I misunderstand anything?



