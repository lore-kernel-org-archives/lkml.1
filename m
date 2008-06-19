Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbYFSARn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbYFSARn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbYFSARf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:17:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46188 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbYFSARe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:17:34 -0400
Date: Thu, 19 Jun 2008 09:22:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [Experimental][PATCH] putback_lru_page rework
Message-Id: <20080619092242.79648592.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1213813266.6497.14.camel@lts-notebook>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org>
	<20080617163501.7cf411ee.nishimura@mxp.nes.nec.co.jp>
	<20080617164709.de4db070.nishimura@mxp.nes.nec.co.jp>
	<20080618184000.a855dfe0.kamezawa.hiroyu@jp.fujitsu.com>
	<1213813266.6497.14.camel@lts-notebook>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008 14:21:06 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> On Wed, 2008-06-18 at 18:40 +0900, KAMEZAWA Hiroyuki wrote:
> > Lee-san, how about this ?
> > Tested on x86-64 and tried Nisimura-san's test at el. works good now.
> 
> I have been testing with my work load on both ia64 and x86_64 and it
> seems to be working well.  I'll let them run for a day or so.
> 
thank you.
<snip>

> > @@ -240,6 +232,9 @@ static int __munlock_pte_handler(pte_t *
> >  	struct page *page;
> >  	pte_t pte;
> >  
> > +	/*
> > +	 * page is never be unmapped by page-reclaim. we lock this page now.
> > +	 */
> 
> I don't understand what you're trying to say here.  That is, what the
> point of this comment is...
> 
We access the page-table without taking pte_lock. But this vm is MLOCKED
and migration-race is handled. So we don't need to be too nervous to access
the pte. I'll consider more meaningful words.

Thanks,
-Kame

