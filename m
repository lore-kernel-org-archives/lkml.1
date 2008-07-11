Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbYGKFJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbYGKFJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 01:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYGKFJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 01:09:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44719 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbYGKFJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 01:09:29 -0400
Date: Fri, 11 Jul 2008 14:15:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Cc: menage@google.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       linux-mm@kvack.org
Subject: Re: [PATCH][RFC] dirty balancing for cgroups
Message-Id: <20080711141511.515e69a5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080711040657.87AE71E3DF1@siro.lan>
References: <20080711085449.ba7d14dd.kamezawa.hiroyu@jp.fujitsu.com>
	<20080711040657.87AE71E3DF1@siro.lan>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 13:06:57 +0900 (JST)
yamamoto@valinux.co.jp (YAMAMOTO Takashi) wrote:

> hi,
> 
> > On Wed,  9 Jul 2008 15:00:34 +0900 (JST)
> > yamamoto@valinux.co.jp (YAMAMOTO Takashi) wrote:
> > 
> > > hi,
> > > 
> > > the following patch is a simple implementation of
> > > dirty balancing for cgroups.  any comments?
> > > 
> > > it depends on the following fix:
> > > 	http://lkml.org/lkml/2008/7/8/428
> > > 
> > 
> > A few comments  ;)
> 
> thanks for comments.
> 
> >  - This looks simple but, could you merge this into memory resource controller ?
> 
> why?
> 
3 points.
 1. Is this useful if used alone ?
 2. memcg requires this kind of feature, basically.
 3. I wonder I need more work to make this work well under memcg.

If chasing page->cgroup and memcg make this patch much more complex,
I think this style of implimentation is a choice.

 About 3. 
    Does this works well if I changes get_dirty_limit()'s
    determine_dirtyable_memory() calculation under memcg ?
    But to do this seems not valid if dirty_ratio cgroup and memcg cgroup 
    containes different set of tasks.
 
Thanks,
-Kame

