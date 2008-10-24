Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYJXFvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYJXFvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 01:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYJXFvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 01:51:36 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38396 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbYJXFvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 01:51:36 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC][PATCH] lru_add_drain_all() don't use schedule_on_each_cpu()
Cc: kosaki.motohiro@jp.fujitsu.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20081024053402.GA11725@wotan.suse.de>
References: <20081024140723.9C49.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081024053402.GA11725@wotan.suse.de>
Message-Id: <20081024144138.9C4C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri, 24 Oct 2008 14:51:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Oct 24, 2008 at 02:29:18PM +0900, KOSAKI Motohiro wrote:
> > > > > I don't see a better way to solve it, other than avoiding lru_add_drain_all
> > > > 
> > > > Well,
> > > > 
> > > > Unfortunately, lru_add_drain_all is also used some other VM place
> > > > (page migration and memory hotplug).
> > > > and page migration's usage is the same of this mlock usage.
> > > > (1. grab mmap_sem  2.  call lru_add_drain_all)
> > > > 
> > > > Then, change mlock usage isn't solution ;-)
> > > 
> > > No, not mlock alone.
> > 
> > Ah, I see.
> > It seems difficult but valuable. I'll think this way for a while.
> 
> Well, I think it would be nice if we can reduce lru_add_drain_all,
> however your patch might be the least intrusive and best short term
> solution.

Yup, thanks.

I also think my way is the best solustion of 2.6.28 age.
and I should work on your better solution for long term.




