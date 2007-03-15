Return-Path: <linux-kernel-owner+w=401wt.eu-S1422986AbXCOXPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422986AbXCOXPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 19:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422992AbXCOXPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 19:15:52 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:34453 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422986AbXCOXPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 19:15:50 -0400
Subject: Re: [PATCH] mm/filemap.c: unconditionally call mark_page_accessed
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Andrea Arcangeli <andrea@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Ashif Harji <asharji@cs.uwaterloo.ca>,
       Miquel van Smoorenburg <miquels@cistron.nl>, linux-mm@kvack.org,
       Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20070315225928.GF6687@v2.random>
References: <20070312143900.GB6016@wotan.suse.de>
	 <20070312151355.GB23532@duck.suse.cz>
	 <Pine.GSO.4.64.0703121247210.7679@cpu102.cs.uwaterloo.ca>
	 <20070312173500.GF23532@duck.suse.cz>
	 <Pine.GSO.4.64.0703131438580.8193@cpu102.cs.uwaterloo.ca>
	 <20070313185554.GA5105@duck.suse.cz>
	 <Pine.GSO.4.64.0703141218530.28958@cpu102.cs.uwaterloo.ca>
	 <45F96CCB.4000709@redhat.com> <20070315162944.GI8321@wotan.suse.de>
	 <Pine.LNX.4.64.0703151719380.32335@blonde.wat.veritas.com>
	 <20070315225928.GF6687@v2.random>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 18:15:45 -0500
Message-Id: <1174000545.14380.22.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 23:59 +0100, Andrea Arcangeli wrote:
> On Thu, Mar 15, 2007 at 05:44:01PM +0000, Hugh Dickins wrote:
> > who removed the !offset condition, he should be consulted on its
> > reintroduction.
> 
> the !offset check looks a pretty broken heuristic indeed, it would
> break random I/O.

I wouldn't call it broken.  At worst, I'd say it's imperfect.  But
that's the nature of a heuristic.  It most likely works in a huge
majority of cases.

> The real fix is to add a ra.prev_offset along with
> ra.prev_page, and if who implements it wants to be stylish he can as
> well use a ra.last_contiguous_read structure that has a page and
> offset fields (and then of course remove ra.prev_page).

I suggested something along these lines, but I wonder if it's overkill.
The !offset check is simple and appears to be a decent improvement over
the current code.
-- 
David Kleikamp
IBM Linux Technology Center

