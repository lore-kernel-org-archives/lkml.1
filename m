Return-Path: <linux-kernel-owner+w=401wt.eu-S1752785AbYKMDjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbYKMDjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 22:39:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYKMDi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 22:38:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36090 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYKMDiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 22:38:55 -0500
Date: Thu, 13 Nov 2008 12:38:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, nishimura@mxp.nes.nec.co.jp,
       Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH 1/6] memcg: free all at rmdir
Message-Id: <20081113123816.873477a1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <491B9E8B.3080301@linux.vnet.ibm.com>
References: <20081112122606.76051530.kamezawa.hiroyu@jp.fujitsu.com>
	<20081112122656.c6e56248.kamezawa.hiroyu@jp.fujitsu.com>
	<20081112160758.3dca0b22.akpm@linux-foundation.org>
	<20081113114908.42a6a8a7.kamezawa.hiroyu@jp.fujitsu.com>
	<491B9BB3.6010701@linux.vnet.ibm.com>
	<20081113122241.b77a0d14.kamezawa.hiroyu@jp.fujitsu.com>
	<491B9E8B.3080301@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 08:57:07 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Thu, 13 Nov 2008 08:44:59 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> >> KAMEZAWA Hiroyuki wrote:
> >>> On Wed, 12 Nov 2008 16:07:58 -0800
> >>> Andrew Morton <akpm@linux-foundation.org> wrote:
> >>>> If we do this then we can make the above "keep" behaviour non-optional,
> >>>> and the operator gets to choose whether or not to drop the caches
> >>>> before doing the rmdir.
> >>>>
> >>>> Plus, we get a new per-memcg drop_caches capability.  And it's a nicer
> >>>> interface, and it doesn't have the obvious races which on_rmdir has,
> >>>> etc.
> >>>>
> >>>> hm?
> >>>>
> >>> Balbir, how would you want to do ?
> >>>
> >>> I planned to post shrink_uage patch later (it's easy to be implemented) regardless
> >>> of acceptance of this patch.
> >>>
> >>> So, I think we should add shrink_usage now and drop this is a way to go.
> >> I am a bit concerned about dropping stuff at will later. Ubuntu 8.10 has memory
> >> controller enabled and we exposed memory.force_empty interface there and now
> >> we've dropped it (bad on our part). I think we should have deprecated it and
> >> dropped it later.
> >>
> > I *was* documented as "for debug only".
> > 
> 
> I know, but I suspect users won't. I am not blaming you in person, just trying
> the find way to do such things. I think I've seen sysfs add a deprecated option
> and put all deprecated files there, they are only created if someone cares about
> them.
>
Ah, but it should be done in cgroup layer. 

> > Hmm, adding force_empty again to do "shrink usage to 0" is another choice.
> 
> Yes, sounds reasonable.
> 
ok, will post a patch today.

Thanks,
-Kame

