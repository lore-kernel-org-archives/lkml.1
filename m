Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbZH1PH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbZH1PH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 11:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZH1PH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 11:07:27 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:56411 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbZH1PH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 11:07:26 -0400
Date: Fri, 28 Aug 2009 20:37:23 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 1/5] memcg: change for softlimit.
Message-ID: <20090828150723.GQ4889@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com> <20090828132321.e4a497bb.kamezawa.hiroyu@jp.fujitsu.com> <20090828072007.GH4889@balbir.in.ibm.com> <20090828163523.e51678be.kamezawa.hiroyu@jp.fujitsu.com> <20090828132643.GM4889@balbir.in.ibm.com> <bfd50d44ff730c2720b882a81b7446c6.squirrel@webmail-b.css.fujitsu.com> <20090828144539.GN4889@balbir.in.ibm.com> <d50640bcbd1bb174caaca9714bbe03e5.squirrel@webmail-b.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <d50640bcbd1bb174caaca9714bbe03e5.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28 23:58:39]:

> Balbir Singh wrote:
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28
> > 23:29:09]:
> >
> >> Balbir Singh wrote:
> >> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28
> >> > 16:35:23]:
> >> >
> >>
> >> >>
> >> >> Current soft-limit RB-tree will be easily broken i.e. not-sorted
> >> >> correctly
> >> >> if used under use_hierarchy=1.
> >> >>
> >> >
> >> > Not true, I think the sorted-ness is delayed and is seen when we pick
> >> > a tree for reclaim. Think of it as being lazy :)
> >> >
> >> plz explain how enexpectedly unsorted RB-tree can work sanely.
> >>
> >>
> >
> > There are two checks built-in
> >
> > 1. In the reclaim path (we see how much to reclaim, compared to the
> > soft limit)
> > 2. In the dequeue path where we check if we really are over soft limit
> >
> that's not a point.
> 
> > I did lot of testing with the time based approach and found no broken
> > cases, I;ve been testing it with the mmotm (event based approach and I
> > am yet to see a broken case so far).
> >
> I'm sorry if I don't understand RB-tree.
> I think RB-tree is a system which can sort inputs passed by caller
> one by one and will be in broken state if value of nodes changed
> while it's in tree. Wrong ?
> While a subtree is
>                7
>               / \
>              3   9
> And, by some magic, the value can be changed without extract
>                7
>               / \
>              13  9
> The biggest is 13. But the biggest number which will be selecte will be "9".
>

This cannot happen today, we keep the values the same till we update
the tree. I hope that clarifies. 

-- 
	Balbir
