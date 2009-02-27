Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZB0FMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZB0FMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 00:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZB0FMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 00:12:33 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:47099 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbZB0FMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 00:12:32 -0500
Date: Fri, 27 Feb 2009 10:42:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cgroup allow subsys to set default mode of its own
	file
Message-ID: <20090227051225.GR11421@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090225163555.d2a0b24c.kamezawa.hiroyu@jp.fujitsu.com> <20090226130005.3282cb02.akpm@linux-foundation.org> <20090227092031.f42cbbbe.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090227092031.f42cbbbe.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-02-27 09:20:31]:

> On Thu, 26 Feb 2009 13:00:05 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 25 Feb 2009 16:35:55 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > >  When I wrote tools for maintain cgroup, I can't find which file is
> > >  writable intarfece or not via cgroup file systems. (finally, I did
> > >  dirty approach.)
> > >  IMHO, showing "this file is read-only" in explicit way is useful
> > >  for user-land (tools). In other story, a file whose name sounds read-only
> > >  may have "trigger" operation and support reseting. In this case,
> > >  "writable" is informative.
> > 
> > Well, we have compatibility issues here.  If we make this change, and
> > people write tools which depend upon that change then those tools might
> > break when run upon older kernels.  Or they need back-compatibility
> > additions, which increases the testing burden of those tools.
> > 
> > One way in which we could improve this situation is to backport these
> > changes into earlier kernels, although I don't know which versions.
> > 
> > What do we think?
> > 
> It sounds problem to me.
> 
> Hmm..1st commit to kernel/cgroup.c is 2007-10-19, then 2.6.24 is the oldest one.
> But I think distro's tools for cgroup is not as old as...
> Hmm, backport to 2.6.25 is enough ?
> Balbir, how do you think ? I think you are familiar with libcgroup.
>

Actually this problem fixes an issue that we've seen in libcgroup,
where a file would have read permission (force_empty), but reading it
would fail, Porting back to 2.6.25 would be nice (since the memcg
merge) 

-- 
	Balbir
