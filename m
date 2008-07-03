Return-Path: <linux-kernel-owner+w=401wt.eu-S1760446AbYGCNRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446AbYGCNRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759392AbYGCNRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:17:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759271AbYGCNRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:17:20 -0400
Date: Thu, 3 Jul 2008 09:16:37 -0400
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kosaki.motohiro@jp.fujitsu.com,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Benjamin Kidwell <benjkidwell@yahoo.com>
Subject: Re: [-mm][PATCH 1/10] fix UNEVICTABLE_LRU and !PROC_PAGE_MONITOR
 build
Message-ID: <20080703091637.5fcb0308@bree.surriel.com>
In-Reply-To: <20080703145454.B963.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080625185950.D84F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080702223652.3b57dc4b.akpm@linux-foundation.org>
	<20080703145454.B963.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jul 2008 15:02:23 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > >  config UNEVICTABLE_LRU
> > >  	bool "Add LRU list to track non-evictable pages"
> > >  	default y
> > > +	select PAGE_WALKER
> > 
> > So what do we do?  Make UNEVICTABLE_LRU depend on CONFIG_MMU?  That
> > would be even worse than what we have now.
> 
> I'm not sure about what do we do. but I'd prefer "depends on MMU".
> because current munlock implementation need pagewalker.
> So, munlock rewriting have high risk rather than change depend on.
> 
> Rik, What do you think?

I suspect that systems without an MMU will not run into
page replacement scalability issues, so making the
UNEVICTABLE_LRU config option depend on MMU should be
ok.

-- 
All rights reversed.
