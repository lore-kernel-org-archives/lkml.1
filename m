Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbZE0Bfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbZE0Bfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbZE0Bfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:35:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48828 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZE0Bfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:35:43 -0400
Date: Wed, 27 May 2009 10:34:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] cgroups: handle failure of cgroup_populate_dir() at 
 mount/remount
Message-Id: <20090527103404.81d3c1a4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A1C9253.3060108@cn.fujitsu.com>
References: <4A16153C.2080004@cn.fujitsu.com>
	<20090522172545.1e5e5f81.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830905261506x480f2167naf1034177bbc7036@mail.gmail.com>
	<4A1C9253.3060108@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 09:07:31 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> Paul Menage wrote:
> > On Fri, May 22, 2009 at 1:25 AM, KAMEZAWA Hiroyuki
> > <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >> Hm, shouldn't we allow "noprefix" to be effective only agaisnt cpuset ?
> >> I think it's just for backward-compatibility of cpuset.
> >> (I don't like the option at all.)
> > 
> > Yes, exposing the "noprefix" option externally was one of the mistakes
> > I made when developing cgroups.
> > 
> > It seems to me really unlikely that anyone is using "noprefix" for
> 
> And "noprefix" is not documented in cgroups.txt, so I guess not
> many people know this option. Even libcgroup doesn't handle it.
> 
> > anything other than implicitly when mounting the "cpuset" filesystem.
> > So I'd be inclined to just forbid it if we're mounting more than just
> > the cpuset subsystem. A bit of a nasty abstraction violation, but it
> > makes more sense overall. The only problem is that someone *might* be
> > using it - do we have any way to determine how, and how big do they
> > have to be before we care?
> > 
> 
> I think we can never know..

How about this method ?

 - add "noprefix" to "to-be-removed" list.
 - add "WARNING: noprefix option will be removed in 2.6.32 (or 2.6.31)" now
 - remove "noprefix" in 2.6.31-rc or later

Thanks,
-Kame





