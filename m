Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbYFMWEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbYFMWEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 18:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYFMWEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 18:04:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629AbYFMWEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 18:04:04 -0400
Date: Fri, 13 Jun 2008 18:03:48 -0400
From: Rik van Riel <riel@redhat.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.26-rc5-mm2 (swap_state.c:77)
Message-ID: <20080613180348.55d3fb67@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.64.0806132135460.10183@blonde.site>
References: <20080609223145.5c9a2878.akpm@linux-foundation.org>
	<200806101848.22237.nickpiggin@yahoo.com.au>
	<20080611140902.544e59ec@bree.surriel.com>
	<200806120958.38545.nickpiggin@yahoo.com.au>
	<20080612152905.6cb294ae@cuia.bos.redhat.com>
	<Pine.LNX.4.64.0806122131330.10415@blonde.site>
	<20080613134507.3f08820e@cuia.bos.redhat.com>
	<Pine.LNX.4.64.0806132135460.10183@blonde.site>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 22:15:01 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> > I guess we'll need per-mapping flags to help determine where
> > a page goes at add_to_page_cache_lru() time.
> 
> The better way would be to add a backing_dev_info flag.  (At one
> point I had been going to criticize your per-mapping AS_UNEVICTABLE,
> to say that one should be a backing_dev_info flag; but no, you're
> right, you've the SHM_LOCK case where it has to be per-mapping.)

Good point.  I'll take a look at that.
 
> > > Am I right to think that the memcontrol stuff is now all broken,
> > > because memcontrol.c hasn't yet been converted to the more LRUs?
> > > Certainly I'm now hanging when trying to run in a restricted memcg.
> > 
> > I believe memcontrol has been converted.  Of course, maybe
> > they changed some stuff under me that I didn't notice :(
> 
> Ah, yes, there are NR_LRU_LISTS arrays in there now, so it has
> the appearance of having been converted.  Fine, then it's worth
> my looking into why it isn't actually working as intended.

I believe that Lee and Kosaki-san have tested this code,
so the breakage could be pretty new.

-- 
All rights reversed.
