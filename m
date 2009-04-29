Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbZD2IGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbZD2IGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 04:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbZD2IGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 04:06:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:61438 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbZD2IGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 04:06:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,265,1239001200"; 
   d="scan'208";a="137151152"
Date: Wed, 29 Apr 2009 16:05:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
Message-ID: <20090429080553.GA14838@localhost>
References: <20090428010907.912554629@intel.com> <20090428014920.769723618@intel.com> <1240940961.938.451.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240940961.938.451.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 01:49:21AM +0800, Matt Mackall wrote:
> On Tue, 2009-04-28 at 09:09 +0800, Wu Fengguang wrote:
> > plain text document attachment (kpageflags-extending.patch)
> > Export 9 page flags in /proc/kpageflags, and 8 more for kernel developers.
> 
> My only concern with this patch is it knows a bit too much about SLUB
> internals (and perhaps not enough about SLOB, which also overloads
> flags). 

Yup. PG_private=PG_slob_free is not masked because SLOB actually does
not set PG_slab at all. I wonder if it's safe to do this change:

        /* SLOB */
-       PG_slob_page = PG_active,
+       PG_slob_page = PG_slab,
        PG_slob_free = PG_private,


In the page-types output:

         flags  page-count       MB  symbolic-flags                     long-symbolic-flags
0x000800000040        7113       27  ______A_________________P____      active,private
0x000000000040          66        0  ______A______________________      active

The above two lines are obviously for SLOB pages.  It indicates lots of
free SLOB pages. So my question is:

- Do you have other means to get the nr_free_slobs info? (I found none in the code)
or
- Will exporting the SL*B overloaded flags going to help?

Thanks,
Fengguang
