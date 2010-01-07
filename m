Return-Path: <linux-kernel-owner+w=401wt.eu-S932612Ab0AGIXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab0AGIXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 03:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932525Ab0AGIXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 03:23:20 -0500
Received: from RELAY-01.ANDREW.CMU.EDU ([128.2.10.212]:40521 "EHLO
	relay.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500Ab0AGIXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 03:23:20 -0500
Date: Thu, 7 Jan 2010 03:22:54 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       bblum@andrew.cmu.edu
Subject: Re: [PATCH v4 0/4] cgroups: support for module-loadable subsystems
Message-ID: <20100107082254.GD16656@andrew.cmu.edu>
Mail-Followup-To: Li Zefan <lizf@cn.fujitsu.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20091231051050.GA714@andrew.cmu.edu> <20100106160414.bd555474.akpm@linux-foundation.org> <20100107012606.GA25577@andrew.cmu.edu> <20100107120732.97d502bd.kamezawa.hiroyu@jp.fujitsu.com> <4B45824B.9030108@cn.fujitsu.com> <20100107081432.GC16656@andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107081432.GC16656@andrew.cmu.edu>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 03:14:32AM -0500, Ben Blum wrote:
> On Thu, Jan 07, 2010 at 02:42:19PM +0800, Li Zefan wrote:
> > KAMEZAWA Hiroyuki wrote:
> > > On Wed, 6 Jan 2010 20:26:06 -0500
> > > Ben Blum <bblum@andrew.cmu.edu> wrote:
> > > 
> > >> On Wed, Jan 06, 2010 at 04:04:14PM -0800, Andrew Morton wrote:
> > >>> On Thu, 31 Dec 2009 00:10:50 -0500
> > >>> Ben Blum <bblum@andrew.cmu.edu> wrote:
> > >>>
> > >>>> This patch series implements support for building, loading, and
> > >>>> unloading subsystems as modules, both within and outside the kernel
> > >>>> source tree. It provides an interface cgroup_load_subsys() and
> > >>>> cgroup_unload_subsys() which modular subsystems can use to register and
> > >>>> depart during runtime. The net_cls classifier subsystem serves as the
> > >>>> example for a subsystem which can be converted into a module using these
> > >>>> changes.
> > >>> What is the value in this?  What are the usage scenarios?  Why does the
> > >>> benefit of this change exceed the cost/risk/etc of merging it?
> > >> As discussed in the first posting of these patches, this provides the
> > >> ability for arbitrary subsystems to be used with cgroups.. cls_cgroup
> > >> would have already been a module except for a lack of support from
> > >> cgroups, and the change also allows other module-loadable classifiers
> > >> to add subsystems of their own.
> > > 
> > > Hmm, do you have your own module in plan ?
> > > 
> > 
> > Maybe the new blkio_cgroup can also be made module-able.
> 
> certainly looks promising. one thing I note while looking over it is
> that it wants .use_id = 1, and the load_subsys interface neglects to
> make a call to init_idr. adding calls to cgroup_init_idr has a few
> possible complications... what use does blkio have for use_id?

oh, oops, while tracing the calls that init_idr does i ended up looking
at the wrong functions and made it out to be harder than it was (in
several places, even). still it would need to be included in load_subsys
and the single error case handled appropriately.
