Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbZEYJrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbZEYJrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 05:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZEYJrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 05:47:13 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:46840 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbZEYJrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 05:47:12 -0400
Date: Mon, 25 May 2009 15:17:04 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       libcg-devel@lists.sourceforge.net
Subject: Re: [PATCH] cgroups: handle failure of cgroup_populate_dir() at
	mount/remount
Message-ID: <20090525094704.GA5709@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <4A16153C.2080004@cn.fujitsu.com> <20090522172545.1e5e5f81.kamezawa.hiroyu@jp.fujitsu.com> <4A1663C2.4080401@cn.fujitsu.com> <20090522173421.ecacb40e.kamezawa.hiroyu@jp.fujitsu.com> <20090522091034.GC8696@linux.vnet.ibm.com> <4A1A6192.6050608@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1A6192.6050608@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 05:14:58PM +0800, Li Zefan wrote:
> Dhaval Giani wrote:
> > On Fri, May 22, 2009 at 05:34:21PM +0900, KAMEZAWA Hiroyuki wrote:
> >> On Fri, 22 May 2009 16:35:14 +0800
> >> Li Zefan <lizf@cn.fujitsu.com> wrote:
> >>
> >>> KAMEZAWA Hiroyuki wrote:
> >>>> On Fri, 22 May 2009 11:00:12 +0800
> >>>> Li Zefan <lizf@cn.fujitsu.com> wrote:
> >>>>
> >>>>> Now we have 'stat' file in both memory and cpuacct subsystems. If we
> >>>>> mount these 2 subsystems with option 'noprefix', the creation of 'stat'
> >>>>> file for cpuacct will fail, but without any notificatin to the user.
> >>>>>
> >>>>> With this patch, we fail the mount/remount in this case.
> >>>>>
> >>>> Hm, shouldn't we allow "noprefix" to be effective only agaisnt cpuset ?
> >>>> I think it's just for backward-compatibility of cpuset.
> >>>> (I don't like the option at all.)
> >>>>
> >>> Yes, this mount option was introduced for cpuset. But it has been here for
> >>> a long time and people may use it when mounting other cgroup subsystems,
> >>> then is it OK to change to restrict its use within cpuset only?
> >> Asking libcgroup people may be appropriate...added CC.
> > 
> > We just realized that we were not handling the noprefix usage in
> 
> I guess handling noprefix will increase complexity of libcgroup? since we
> can't figure out which subsystem the file belongs to by looking at the
> prefix of the file.
> 

Yes, but that should be handled with the next set of features planned
for the library.

> > libcgroup. From the pov of the library, the option should either not
> > exist for any subsystem or for all of them. Anything else would mean
> > having to add special cases.
> > 
> 
> I don't see how to totally remove 'noprefix' while keep the backward 
> compatibility of cpuset, so I think we have to reserve it, and fix
> name collision caused by this option.

I agree with you.

-- 
regards,
Dhaval
