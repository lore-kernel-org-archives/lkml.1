Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbYDOHh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbYDOHh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbYDOHhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:37:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752766AbYDOHhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:37:13 -0400
Date: Tue, 15 Apr 2008 00:36:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [patch 2/2] bootmem: Node-setup agnostic free_bootmem()
Message-Id: <20080415003647.922a9a05.akpm@linux-foundation.org>
In-Reply-To: <86802c440804150028t33fabd7fn40d3d47d0482bfc1@mail.gmail.com>
References: <20080412223319.372887160@symbol.fehenstaub.lan>
	<20080412225850.704752615@symbol.fehenstaub.lan>
	<87lk3hwv52.fsf@basil.nowhere.org>
	<20080414232308.ffa4e269.akpm@linux-foundation.org>
	<86802c440804150004w1c94b2dci520e0ffb8b60632f@mail.gmail.com>
	<20080415001512.60cb784d.akpm@linux-foundation.org>
	<86802c440804150028t33fabd7fn40d3d47d0482bfc1@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 00:28:34 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On Tue, Apr 15, 2008 at 12:15 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > On Tue, 15 Apr 2008 00:04:03 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> >
> >  > On Mon, Apr 14, 2008 at 11:23 PM, Andrew Morton
> >  > <akpm@linux-foundation.org> wrote:
> >  > >
> >  > > On Sun, 13 Apr 2008 18:56:57 +0200 Andi Kleen <andi@firstfloor.org> wrote:
> >  > >
> >  > >  > Johannes Weiner <hannes@saeurebad.de> writes:
> >  > >  >
> >  > >  > > Make free_bootmem() look up the node holding the specified address
> >  > >  > > range which lets it work transparently on single-node and multi-node
> >  > >  > > configurations.
> >  > >  >
> >  > >  > Acked-by: Andi Kleen <andi@firstfloor.org>
> >  > >  >
> >  > >  > This is far better than the original change it replaces and which
> >  > >  > I also objected to in review.
> >  > >  >
> >  > >
> >  > >  So...  do we think these two patches are sufficiently safe and important for
> >  > >  2.6.25?
> >  >
> >  > the patch is wrong
> >  >
> >
> >  The last I saw was this:
> >
> >
> >  On Sun, 13 Apr 2008 12:57:22 +0200 Johannes Weiner <hannes@saeurebad.de> wrote:
> >
> >  > Hi,
> >  >
> >  > "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> >  >
> >  > > On Sat, Apr 12, 2008 at 3:33 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
> >  > > ...
> >
> > > >
> >  > > could have chance that bootmem with reserved_early that is crossing
> >  > > the nodes.
> >  >
> >  > Upstream reserve_bootmem_core() would BUG() on a caller trying to cross
> >  > nodes, so I don't see where this chance could come from.
> >
> >  Is that what you're referring to?
> >
> >  Was Johannes observation incorrect?  If so, why?
> 
> my patch with free_bootmem will make sure free_bootmem_core only free
> bootmem in the bdata scope.
> so free_bootmem can handle the cross_node bootmem that is done by
> reserve_early ( done in another patch, is dropped by you because took
> Jonannes).
> 
> in setup_arch for x86_64 there is one free_bootmem that is used when
> ramdisk is falled out of ram map. that could be crossed by bootloader
> and kexec, and kernel or second kernel is memmap=NN@SS to execlue some
> memory.
> 
> anyway that is extrem case, but my patch could handle that.
> 
> I wonder if any regression caused by my previous patch? maybe on other platform?
> 

Not that I'm aware of.

I restored mm-make-reserve_bootmem-can-crossed-the-nodes.patch.  Johannes,
can you please check 2.6.28-rc8-mm2, see if it looks OK?
