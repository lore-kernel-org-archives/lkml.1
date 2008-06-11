Return-Path: <linux-kernel-owner+w=401wt.eu-S1762606AbYFKQBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762606AbYFKQBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 12:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYFKQBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 12:01:03 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:3892 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYFKQBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 12:01:02 -0400
Subject: Re: [PATCH -mm 17/25] Mlocked Pages are non-reclaimable
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: riel@redhat.com, npiggin@suse.de, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, eric.whitney@hp.com
In-Reply-To: <20080610145706.4a921cfa.akpm@linux-foundation.org>
References: <20080606202838.390050172@redhat.com>
	 <20080606202859.522708682@redhat.com>
	 <20080606180746.6c2b5288.akpm@linux-foundation.org>
	 <20080610033130.GK19404@wotan.suse.de>
	 <20080610171400.149886cf@cuia.bos.redhat.com>
	 <1213134197.6872.49.camel@lts-notebook>
	 <20080610145706.4a921cfa.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 11 Jun 2008 12:01:24 -0400
Message-Id: <1213200084.6436.31.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-10 at 14:57 -0700, Andrew Morton wrote:
> On Tue, 10 Jun 2008 17:43:17 -0400
> Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> 
> > Couple of related items:
> > 
> > + 26-rc5-mm1 + a small fix to the double unlock_page() in
> > shrink_page_list() has been running for a couple of hours on my 32G,
> > 16cpu ia64 numa platform w/o error.  Seems to have survived the merge
> > into -mm, despite the issues Andrew has raised.
> 
> oh goody, thanks.  

I should have mentioned that it's running a fairly heavy stress load to
exercise the vm scalability changes.  Lots of IO, page cache activity,
swapping, mlocking and shmlocking various sized regions, up to 16GB on
32GB machine, migrating of mlocked/shmlocked segments between
nodes,  ...   So far today, the load has been up for ~19.5 hours with no
errors, no softlockups, no oom-kills or such.  

> Johannes's bootmem rewrite is holding up
> surprisingly well.

Well, I am seeing a lot of "potential offnode page_structs" messages for
our funky cache-line interleaved pseudo-node.  I had to limit the prints
to boot at all.  Still investigating.  Looks like slub can't allocate
its initial per node data on that node either.

> 
> gee test.kernel.org takes a long time.
> 
> > + on same platform, Mel Gorman's mminit debug code is reporting that
> > we're using 22 page flags with Noreclaim, Mlock and PAGEFLAGS_EXTENDED
> > configured.
> 
> what is "Mel Gorman's mminit debug code"?

mminit_loglevel={0|1|2}  [I use 3 :)]  shows page flag layout, zone
lists, ...

