Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab0BSPCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:02:45 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:53858 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab0BSPCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:02:44 -0500
Date: Fri, 19 Feb 2010 09:01:44 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 03/12] mm: Share the anon_vma ref counts between KSM and
 page migration
In-Reply-To: <20100219140500.GG30258@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1002190857230.7486@router.home>
References: <1266516162-14154-1-git-send-email-mel@csn.ul.ie> <1266516162-14154-4-git-send-email-mel@csn.ul.ie> <20100219091859.195d922c.kamezawa.hiroyu@jp.fujitsu.com> <20100219140500.GG30258@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Feb 2010, Mel Gorman wrote:

> > Nitpick:
> > I think this refcnt has something different characteristics than other
> > usual refcnts. Even when refcnt goes down to 0, anon_vma will not be freed.
> > So, I think some kind of name as temporal_reference_count is better than
> > simple "refcnt". Then, it will be clearer what this refcnt is for.
> >
>
> When I read this in a few years, I'll have no idea what "temporal" is
> referring to. The holder of this account is by a process that does not
> necessarily own the page or its mappings but "remote" has special
> meaning as well. "external_count" ?

We could think about getting rid of RCU for anon_vmas and use the refcount
for everything. Would make the handling consistent with other users but
will have performance implications.

Hugh what do you say about this?

