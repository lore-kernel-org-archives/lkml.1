Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbYHHIvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbYHHIvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 04:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYHHIvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 04:51:46 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:56980 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbYHHIvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 04:51:45 -0400
Date: Fri, 8 Aug 2008 09:51:36 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Francis Moreau <francis.moro@gmail.com>
cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: question about do_anonymous_page()
In-Reply-To: <38b2ab8a0808080123t5083dc17qa250bd02c753f80d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0808080938001.15941@blonde.site>
References: <38b2ab8a0808080101v795327f0n9da5adb33a3c1a9@mail.gmail.com>
 <38b2ab8a0808080123t5083dc17qa250bd02c753f80d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008, Francis Moreau wrote:
> On Fri, Aug 8, 2008 at 10:01 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> >
> > I'm wondering why do_anonymous_page() calls lru_cache_add_active(page)
> > where page does not belong to the page cache ?
> >
> > Is it simply because lru_add_active() doesn't exist ?

Yes.

It just happens that whoever (Rik?) originally named that function was
primarily thinking of the page cache at the time; or perhaps wasn't
thinking of the file page cache at all, just regarding all the pages
we put on that list as cached in some sense.

You're right that it's a little anomalous, but nothing to worry about.
I get more bothered by page_cache_get(), which is and always(?) has
been the same thing as get_page(): sometimes we use one, sometimes
the other, and often we use page_cache_get() on anonymous pages.

Hugh
