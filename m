Return-Path: <linux-kernel-owner+w=401wt.eu-S1762049AbZLKCOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762049AbZLKCOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 21:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbZLKCOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 21:14:05 -0500
Received: from mga14.intel.com ([143.182.124.37]:22251 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757287AbZLKCOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 21:14:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="221361606"
Date: Fri, 11 Dec 2009 10:14:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Paul Menage <menage@google.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "Li, Haicheng" <haicheng.li@intel.com>
Subject: Re: [PATCH] [23/31] HWPOISON: add memory cgroup filter
Message-ID: <20091211021405.GA10693@localhost>
References: <200912081016.198135742@firstfloor.org> <20091208211639.8499FB151F@basil.firstfloor.org> <6599ad830912091247v1270a86er45ea8ceeff28e727@mail.gmail.com> <20091210014212.GI18989@one.firstfloor.org> <20091210022113.GJ3722@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210022113.GJ3722@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 10:21:13AM +0800, Balbir Singh wrote:
> * Andi Kleen <andi@firstfloor.org> [2009-12-10 02:42:12]:
> 
> > > While the functionality sounds useful, the interface (passing an inode
> > > number) feels a bit ugly to me. Also, if that group is deleted and a
> > > new cgroup created, you could end up reusing the inode number.
> > 
> > Please note this is just a testing interface, doesn't need to be
> > 100% fool-proof. It'll never be used in production.
> > 
> > > 
> > > How about an approach where you write either the cgroup path (relative
> > > to the memcg mount) or an fd open on the desired cgroup? Then you
> > > could store a (counted) css reference rather than an inode number,
> > > which would make the filter function cleaner too, since it would just
> > > need to compare css objects.
> > 
> > Sounds complicated, I assume it would be much more code?
> > I would prefer to keep the testing interfaces as simple as possible.
> >
> 
> We do this for cgroupstats and the code is not very complicated. In
> case you want to look, the user space code is at
> Documentation/accounting/getdelays.c and the kernel code is in
> kernel/taskstats.c 

Balbir, thanks for the tip.

We could keep an fd open on the desired cgroup, in user space: 

        #!/bin/bash

        mkdir /cgroup/hwpoison && \
        exec 9<>/cgroup/hwpoison/tasks || exit 1

A bit simpler than an in-kernel fget_light() or CSS refcount :)

Thanks,
Fengguang
