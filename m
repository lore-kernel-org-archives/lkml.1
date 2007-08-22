Return-Path: <linux-kernel-owner+w=401wt.eu-S1750954AbXHVAKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750954AbXHVAKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 20:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbXHVAJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 20:09:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60348 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbXHVAJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 20:09:48 -0400
Date: Wed, 22 Aug 2007 09:11:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH][2.6.23-rc2-mm2] small fix for ia64 icache sync patch
Message-Id: <20070822091129.8c300281.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <617E1C2C70743745A92448908E030B2A023B2254@scsmsx411.amr.corp.intel.com>
References: <20070821201507.36641d76.kamezawa.hiroyu@jp.fujitsu.com>
	<617E1C2C70743745A92448908E030B2A023B2254@scsmsx411.amr.corp.intel.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007 14:12:02 -0700
"Luck, Tony" <tony.luck@intel.com> wrote:

> > +	if (pte_present(pteval) &&// swap out ?
> > +	    pte_exec(pteval) &&    // flush only new executable page.
> > 	    pte_user(pteval) &&    // ignore kernel page
> > 	    (!pte_present(*ptep) ||// do_no_page or swap in, migration,
> > 		pte_pfn(*ptep) != pte_pfn(pteval))) // do_wp_page(), page copy
> 
> David Mosberger was concerned about the increase in code
> size from this inline function.  We can reduce the bloat
> a bit by defining a macro that tests for "present &&
> executable && user-mode" in one go:
> 
> #define pte_pux(pte)            ((pte_val(pte) & (_PAGE_P|_PAGE_PL_MASK|_PAGE_AR_RX)) == \
>                                         (_PAGE_P|_PAGE_PL_3|_PAGE_AR_RX))
> 
Hmm, ok.

> Perhaps there is a better name than "pte_pux"?  I don't know whether
> the code that this generates is faster, but it is smaller (bloat
> is only 3k instead of 4k).
> 
> One last cleanup needed ... don't use C-99/C++ style comments.
> 
ok.

-Kame

