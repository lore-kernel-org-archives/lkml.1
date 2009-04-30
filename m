Return-Path: <linux-kernel-owner+w=401wt.eu-S1762178AbZD3JnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762178AbZD3JnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 05:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbZD3Jm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 05:42:57 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:52301 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbZD3Jm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 05:42:56 -0400
Date: Thu, 30 Apr 2009 15:12:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hugh@veritas.com" <hugh@veritas.com>
Subject: Re: [PATCH] memcg: fix stale swap cache leak v5
Message-ID: <20090430094252.GG4430@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090430161627.0ccce565.kamezawa.hiroyu@jp.fujitsu.com> <20090430163539.7a882cef.kamezawa.hiroyu@jp.fujitsu.com> <20090430180426.25ae2fa6.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090430180426.25ae2fa6.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-30 18:04:26]:

> On Thu, 30 Apr 2009 16:35:39 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Thu, 30 Apr 2009 16:16:27 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > This is v5 but all codes are rewritten.
> > > 
> > > After this patch, when memcg is used,
> > >  1. page's swapcount is checked after I/O (without locks). If the page is
> > >     stale swap cache, freeing routine will be scheduled.
> > >  2. vmscan.c calls try_to_free_swap() when __remove_mapping() fails.
> > > 
> > > Works well for me. no extra resources and no races.
> > > 
> > > Because my office will be closed until May/7, I'll not be able to make a
> > > response. Posting this for showing what I think of now.
> > > 
> > I found a hole immediately after posted this...sorry. plz ignore this patch/
> > see you again in the next month.
> > 
> I'm now wondering to disable "swapin readahed" completely when memcg is used...
> Then, half of the problems will go away immediately.
> And it's not so bad to try to free swapcache if swap writeback ends. Then, another
> half will go away...
>

Could you clarify? Will memcg not account for swapin readahead pages?
 

-- 
	Balbir
