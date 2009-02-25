Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbZBYAC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbZBYAC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 19:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbZBYACR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 19:02:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527AbZBYACQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 19:02:16 -0500
Date: Tue, 24 Feb 2009 16:01:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, penberg@cs.helsinki.fi, riel@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org,
       hannes@cmpxchg.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       ming.m.lin@intel.com, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 20/20] Get rid of the concept of hot/cold page freeing
Message-Id: <20090224160103.df238662.akpm@linux-foundation.org>
In-Reply-To: <20090224115126.GB25151@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
	<1235344649-18265-21-git-send-email-mel@csn.ul.ie>
	<20090223013723.1d8f11c1.akpm@linux-foundation.org>
	<20090223233030.GA26562@csn.ul.ie>
	<20090223155313.abd41881.akpm@linux-foundation.org>
	<20090224115126.GB25151@csn.ul.ie>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009 11:51:26 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> > > Almost the opposite with steady improvements almost all the way through.
> > > 
> > > With the patch applied, we are still using hot/cold information on the
> > > allocation side so I'm somewhat surprised the patch even makes much of a
> > > difference. I'd have expected the pages being freed to be mostly hot.
> > 
> > Oh yeah.  Back in the ancient days, hot-cold-pages was using separate
> > magazines for hot and cold pages.  Then Christoph went and mucked with
> > it, using a single queue.  That might have affected things.
> > 
> 
> It might have. The impact is that requests for cold pages can get hot pages
> if there are not enough cold pages in the queue so readahead could prevent
> an active process getting cache hot pages. I don't think that would have
> showed up in the microbenchmark though.

We switched to doing non-temporal stores in copy_from_user(), didn't
we?  That would rub out the benefit which that microbenchmark
demonstrated?

