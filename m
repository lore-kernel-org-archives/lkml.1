Return-Path: <linux-kernel-owner+w=401wt.eu-S934071AbXHHQxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934071AbXHHQxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759905AbXHHQxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:53:40 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46009 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756384AbXHHQxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:53:39 -0400
Subject: Re: [RFC][PATCH 1/5] pagemap: remove file header
From: Dave Hansen <haveblue@us.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       serue@us.ibm.com, "ADAM G. LITKE [imap]" <agl@us.ibm.com>
In-Reply-To: <1186590879.22283.99.camel@localhost>
References: <20070807223300.9228E0E0@kernel>
	 <20070808011620.GF30556@waste.org>
	 <20070808023100.222c4d15@the-village.bc.nu>
	 <1186590879.22283.99.camel@localhost>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 09:53:35 -0700
Message-Id: <1186592015.22283.108.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 09:34 -0700, Dave Hansen wrote:
> On Wed, 2007-08-08 at 02:31 +0100, Alan Cox wrote:
> > The information needed to parse /proc/pid/pagemap can be stuck
> > in /proc/pid/somewherelese. If we ever get page size variations and the
> > like then /proc/pid/ is going to end up with that information anyway for
> > ps and friends to use.
> 
> We do at least have some of this with hugetlbfs.  In fact, the current
> pagemap code bugs out when it hits a huge page area:
> 
> /home/dave/work/linux/2.6/22/lxc/mm/memory.c:117: bad pgd 1d0000e7.
> 
> I'll look at fixing that.

I figure we have three options:

1. ignore huge pages completely
2. teach the ->pte_entry handler that ptes can be different sizes,
   and pass the huge ptes into there
3. let the ->pmd_entry handler (or whatever level we've stuck the huge
   page entry in) handle it
4. create new handlers for large pages, like ->huge_pte_entry.  This
   works for now, but what would we do if we have multiple/variable
   large page sizes?

Any other thoughts?

-- Dave

