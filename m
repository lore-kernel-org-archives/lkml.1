Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839Ab0ANLnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab0ANLnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 06:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907Ab0ANLnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 06:43:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738Ab0ANLnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 06:43:33 -0500
Date: Thu, 14 Jan 2010 06:42:43 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, axboe@kernel.dk, ryov@valinux.co.jp,
       Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 2/2] cgroups: blkio subsystem as module
Message-ID: <20100114114243.GC15559@redhat.com>
References: <20091231051050.GA714@andrew.cmu.edu> <20100106160414.bd555474.akpm@linux-foundation.org> <20100107012606.GA25577@andrew.cmu.edu> <20100107120732.97d502bd.kamezawa.hiroyu@jp.fujitsu.com> <4B45824B.9030108@cn.fujitsu.com> <20100108052734.GA13168@andrew.cmu.edu> <20100108053021.GC13168@andrew.cmu.edu> <20100108151038.GA22219@redhat.com> <20100112092106.9ac4e535.kamezawa.hiroyu@jp.fujitsu.com> <661de9471001140132o23f44a4fjb1849d865f96d19a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <661de9471001140132o23f44a4fjb1849d865f96d19a@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 03:02:09PM +0530, Balbir Singh wrote:
> On Tue, Jan 12, 2010 at 5:51 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Fri, 8 Jan 2010 10:10:38 -0500
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> >> On Fri, Jan 08, 2010 at 12:30:21AM -0500, Ben Blum wrote:
> >> > Convert blk-cgroup to be buildable as a module
> >> >
> >> > From: Ben Blum <bblum@andrew.cmu.edu>
> >> >
> >> > This patch modifies the Block I/O cgroup subsystem to be able to be built as a
> >> > module. As the CFQ disk scheduler optionally depends on blk-cgroup, config
> >> > options in block/Kconfig, block/Kconfig.iosched, and block/blk-cgroup.h are
> >> > enhanced to support the new module dependency.
> >> >
> >>
> >> Hi Ben,
> >>
> >> I will give this patch a try.
> >>
> >> So from blk-cgroup perspective, the advantage of allowing it as module
> >> will be that we can save some memory if we are not using the controller?
> >>
> > Is "moduled" blkio cgroup safe after page-tracking by page_cgroup is
> > introduced ?
> >
> 
> My guess is it won't be, unless we start exposing page_cgroup API and
> then make the module depend on memcg.

I think I agree. When we introduce page_cgroup based page tracking, either
we need to export page_cgroup API or we can force blkio controller to
compile as in-kernel if user selects the CONFIG_PAGE_TRACKING option.

So as of now, I can't think why we should not we allow compiling blkio as
module as long as core cgroup functionality supports it safely.

Thanks
Vivek
