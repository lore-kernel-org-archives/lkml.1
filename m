Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZBJKAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZBJKAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 05:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZBJKAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 05:00:32 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40479 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbZBJKAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 05:00:31 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: MinChan Kim <minchan.kim@gmail.com>
Subject: Re: [patch] vmscan: rename sc.may_swap to may_unmap
Cc: kosaki.motohiro@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <28c262360902091502w5555528bt8e61e6c288aeff76@mail.gmail.com>
References: <20090209194309.GA8491@cmpxchg.org> <28c262360902091502w5555528bt8e61e6c288aeff76@mail.gmail.com>
Message-Id: <20090210185936.6FD2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 10 Feb 2009 19:00:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Feb 10, 2009 at 4:43 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > sc.may_swap does not only influence reclaiming of anon pages but pages
> > mapped into pagetables in general, which also includes mapped file
> > pages.
> >
> > From shrink_page_list():
> >
> >                if (!sc->may_swap && page_mapped(page))
> >                        goto keep_locked;
> >
> > For anon pages, this makes sense as they are always mapped and
> > reclaiming them always requires swapping.
> >
> > But mapped file pages are skipped here as well and it has nothing to
> > do with swapping.
> >
> > The real effect of the knob is whether mapped pages are unmapped and
> > reclaimed or not.  Rename it to `may_unmap' to have its name match its
> > actual meaning more precisely.
> >
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> >  mm/vmscan.c |   20 ++++++++++----------
> >  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> It looks good to me. :)
> 
> Reviewed-by: MinChan Kim <minchan.kim@gmail.com>

me too :)

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



