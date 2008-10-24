Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbYJXFeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbYJXFeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 01:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbYJXFeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 01:34:06 -0400
Received: from mx1.suse.de ([195.135.220.2]:53107 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbYJXFeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 01:34:05 -0400
Date: Fri, 24 Oct 2008 07:34:02 +0200
From: Nick Piggin <npiggin@suse.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC][PATCH] lru_add_drain_all() don't use schedule_on_each_cpu()
Message-ID: <20081024053402.GA11725@wotan.suse.de>
References: <20081024135149.9C46.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081024045547.GA24555@wotan.suse.de> <20081024140723.9C49.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024140723.9C49.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 02:29:18PM +0900, KOSAKI Motohiro wrote:
> > > > I don't see a better way to solve it, other than avoiding lru_add_drain_all
> > > 
> > > Well,
> > > 
> > > Unfortunately, lru_add_drain_all is also used some other VM place
> > > (page migration and memory hotplug).
> > > and page migration's usage is the same of this mlock usage.
> > > (1. grab mmap_sem  2.  call lru_add_drain_all)
> > > 
> > > Then, change mlock usage isn't solution ;-)
> > 
> > No, not mlock alone.
> 
> Ah, I see.
> It seems difficult but valuable. I'll think this way for a while.

Well, I think it would be nice if we can reduce lru_add_drain_all,
however your patch might be the least intrusive and best short term
solution.

