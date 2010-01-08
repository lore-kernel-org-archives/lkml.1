Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262Ab0AHF2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab0AHF2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 00:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532Ab0AHF2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 00:28:34 -0500
Received: from RELAY.ANDREW.CMU.EDU ([128.2.10.85]:54364 "EHLO
	relay.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab0AHF2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 00:28:33 -0500
Date: Fri, 8 Jan 2010 00:27:34 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Li Zefan <lizf@cn.fujitsu.com>, axboe@kernel.dk, ryov@valinux.co.jp,
       vgoyal@redhat.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       bblum@andrew.cmu.edu
Subject: Re: [PATCH v4 0/4] cgroups: support for module-loadable subsystems
Message-ID: <20100108052734.GA13168@andrew.cmu.edu>
Mail-Followup-To: Li Zefan <lizf@cn.fujitsu.com>, axboe@kernel.dk,
	ryov@valinux.co.jp, vgoyal@redhat.com,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20091231051050.GA714@andrew.cmu.edu> <20100106160414.bd555474.akpm@linux-foundation.org> <20100107012606.GA25577@andrew.cmu.edu> <20100107120732.97d502bd.kamezawa.hiroyu@jp.fujitsu.com> <4B45824B.9030108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B45824B.9030108@cn.fujitsu.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 02:42:19PM +0800, Li Zefan wrote:
> KAMEZAWA Hiroyuki wrote:
> > On Wed, 6 Jan 2010 20:26:06 -0500
> > Ben Blum <bblum@andrew.cmu.edu> wrote:
> > 
> >> On Wed, Jan 06, 2010 at 04:04:14PM -0800, Andrew Morton wrote:
> >>> On Thu, 31 Dec 2009 00:10:50 -0500
> >>> Ben Blum <bblum@andrew.cmu.edu> wrote:
> >>>
> >>>> This patch series implements support for building, loading, and
> >>>> unloading subsystems as modules, both within and outside the kernel
> >>>> source tree. It provides an interface cgroup_load_subsys() and
> >>>> cgroup_unload_subsys() which modular subsystems can use to register and
> >>>> depart during runtime. The net_cls classifier subsystem serves as the
> >>>> example for a subsystem which can be converted into a module using these
> >>>> changes.
> >>> What is the value in this?  What are the usage scenarios?  Why does the
> >>> benefit of this change exceed the cost/risk/etc of merging it?
> >> As discussed in the first posting of these patches, this provides the
> >> ability for arbitrary subsystems to be used with cgroups.. cls_cgroup
> >> would have already been a module except for a lack of support from
> >> cgroups, and the change also allows other module-loadable classifiers
> >> to add subsystems of their own.
> > 
> > Hmm, do you have your own module in plan ?
> > 
> 
> Maybe the new blkio_cgroup can also be made module-able.

Ok, the following two patches make this happen (or at least pretend to
well enough to fool me). The first one adds use_id initialization in
cgroup_load_subsys, and the second rearranges config options and some
code as appropriate in block/ and adds EXPORT_SYMBOLs in cgroup.c.

-- bblum

---
 block/Kconfig             |    2 -
 block/Kconfig.iosched     |    2 -
 block/blk-cgroup.c        |   53 +++++++++++++++++++++++++++++++++++-----------
 block/blk-cgroup.h        |   10 ++++++--
 include/linux/iocontext.h |    2 -
 kernel/cgroup.c           |   31 +++++++++++++++++++++-----
 6 files changed, 77 insertions(+), 23 deletions(-)

