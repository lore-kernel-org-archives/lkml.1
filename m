Return-Path: <linux-kernel-owner+w=401wt.eu-S1761071AbXGZKix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761071AbXGZKix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 06:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbXGZKip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 06:38:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756276AbXGZKio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 06:38:44 -0400
Date: Thu, 26 Jul 2007 03:38:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       ck list <ck@vds.kolivas.org>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans
 for 2.6.23]
Message-Id: <20070726033809.c1691bb0.akpm@linux-foundation.org>
In-Reply-To: <20070726102730.GA31894@elte.hu>
References: <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	<46A58B49.3050508@yahoo.com.au>
	<2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	<46A6CC56.6040307@yahoo.com.au>
	<p73abtkrz37.fsf@bingen.suse.de>
	<46A85D95.509@kingswood-consulting.co.uk>
	<20070726092025.GA9157@elte.hu>
	<20070726023401.f6a2fbdf.akpm@linux-foundation.org>
	<20070726094024.GA15583@elte.hu>
	<20070726030902.02f5eab0.akpm@linux-foundation.org>
	<20070726102730.GA31894@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 12:27:30 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > > > ( we _do_ want to baloon the dentry cache otherwise - for things like 
> > > > >   "find" - having a fast VFS is important. But known-use-once things 
> > > > >   like the daily updatedb job can clearly be annotated properly. )
> > > > 
> > > > Mutter.  /proc/sys/vm/vfs_cache_pressure has been there for what, 
> > > > three years?  Are any distros raising it during the updatedb run yet?
> > > 
> > > but ... that's system-wide, and the 'dont baloon the dcache' is only a 
> > > property of updatedb.
> > 
> > Sure, but it's practical, isn't it?  Who runs (and cares about) 
> > vfs-intensive workloads during their wee-small-hours updatedb run?
> 
> there's another side-effect: it likely results in the zapping of 
> thousands of dentries that were cached nicely before. So we might 
> exchange 'all my apps are swapped out' experience with 'all file access 
> is slow'. The latter is _probably_ still an improvement over the 
> balooning, but i'm not sure.

Yup.  Nobody has begun to think about preserving dcache/icache across load
shifts yet, afaik.  Hard.

> What we _really_ want is an updatedb that 
> does not disturb the dcache.

Well.  Hopefully this time next year you can prep a 16MB container and toss
your updatedb inside that.  Maybe set its peak disk bandwidth utilisation
too.  However that won't work ;) because I don't think anyone is looking
at containerisation of vfs cache memory yet.  Perhaps full-on openvz has it,
dunno.

But updatedb is a special case, because it is so vfs-intensive.  For lots
of other workloads (those which use heaps of pagecache), resource
management via containerisation will work nicely.
