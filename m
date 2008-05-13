Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbYEMSJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbYEMSJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 14:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbYEMSJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 14:09:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756AbYEMSJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 14:09:20 -0400
Date: Tue, 13 May 2008 14:09:02 -0400
From: Rik van Riel <riel@redhat.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] take pageout refcount into account for
 remove_exclusive_swap_page
Message-ID: <20080513140902.1030afaa@cuia.bos.redhat.com>
In-Reply-To: <1210700635.6208.40.camel@lts-notebook>
References: <20080428181835.502876582@redhat.com>
	<20080428181852.620969450@redhat.com>
	<4828283C.4000803@mxp.nes.nec.co.jp>
	<20080512093307.2ace3096@bree.surriel.com>
	<482990FC.3020303@mxp.nes.nec.co.jp>
	<20080513120417.0833cec1@cuia.bos.redhat.com>
	<1210700635.6208.40.camel@lts-notebook>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 13:43:55 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> Or, more generally, 2 + N, for an anon page that is mapped [must be
> read-only, right?] by N processes.  This can happen after, e.g., fork().
> Looks like this patch handles the condition just fine, but you might
> want to reflect this in the comment.

No, this patch only removes a page from the swap cache that is mapped
by one process.  The function page_mapped() returns either 1 or 0, not
the same as page_mapcount().
 
I am not sure if trying to handle swap cache pages that are mapped by
multiple processes could get us into other corner cases and think that
we should probably try to stick to the safe thing for now.

Besides, shouldn't anonymous shared pages be COW and relatively rare?

> Now, I think I can use this to try to remove anon pages from the swap
> cache when they're mlocked.
> 
> > + */
> > +int remove_exclusive_swap_page_ref(struct page *page)
> > +{
> > +	return remove_exclusive_swap_page_count(page, 2 + page_mapped(page));
> > +}
> > +
> > +/*
> >   * Free the swap entry like above, but also try to
> >   * free the page cache entry if it is the last user.
> >   */
> > 
> > All Rights Reversed


-- 
All Rights Reversed
