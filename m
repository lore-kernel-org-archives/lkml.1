Return-Path: <linux-kernel-owner+w=401wt.eu-S1751870AbYLBHTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbYLBHTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 02:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYLBHTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 02:19:30 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45795 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbYLBHT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 02:19:26 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] memcg: mem_cgroup->prev_priority protected by lock.
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20081202161545.abb884e8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081202160949.1CFE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081202161545.abb884e8.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20081202161837.1D04.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue,  2 Dec 2008 16:19:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue,  2 Dec 2008 16:11:07 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > 
> > Currently, mem_cgroup doesn't have own lock and almost its member doesn't need.
> >  (e.g. info is protected by zone lock, stat is per cpu variable)
> > 
> > However, there is one explict exception. mem_cgroup->prev_priorit need lock,
> > but doesn't protect.
> > Luckly, this is NOT bug because prev_priority isn't used for current reclaim code.
> > 
> > However, we plan to use prev_priority future again.
> > Therefore, fixing is better.
> > 
> > 
> > In addision, we plan to reuse this lock for another member.
> > Then "misc_lock" name is better than "prev_priority_lock".
> > 
> please use better name...reclaim_param_lock or some ?

good idea :)

Will fix.



