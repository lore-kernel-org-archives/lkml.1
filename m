Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbZEHWYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbZEHWYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 18:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbZEHWX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 18:23:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481AbZEHWX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 18:23:56 -0400
Date: Fri, 8 May 2009 15:15:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: fengguang.wu@intel.com, hannes@cmpxchg.org, peterz@infradead.org,
       riel@redhat.com, linux-kernel@vger.kernel.org, tytso@mit.edu,
       linux-mm@kvack.org, elladan@eskimo.com, npiggin@suse.de,
       cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       minchan.kim@gmail.com
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first
 class citizen
Message-Id: <20090508151532.6769e702.akpm@linux-foundation.org>
In-Reply-To: <20090508230045.5346bd32@lxorguk.ukuu.org.uk>
References: <20090430181340.6f07421d.akpm@linux-foundation.org>
	<20090430215034.4748e615@riellaptop.surriel.com>
	<20090430195439.e02edc26.akpm@linux-foundation.org>
	<49FB01C1.6050204@redhat.com>
	<20090501123541.7983a8ae.akpm@linux-foundation.org>
	<20090503031539.GC5702@localhost>
	<1241432635.7620.4732.camel@twins>
	<20090507121101.GB20934@localhost>
	<20090507151039.GA2413@cmpxchg.org>
	<20090507134410.0618b308.akpm@linux-foundation.org>
	<20090508081608.GA25117@localhost>
	<20090508125859.210a2a25.akpm@linux-foundation.org>
	<20090508230045.5346bd32@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009 23:00:45 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > The patch seems reasonable but the changelog and the (non-existent)
> > design documentation could do with a touch-up.
> 
> Is it right that I as a user can do things like mmap my database
> PROT_EXEC to get better database numbers by making other
> stuff swap first ?
>
> You seem to be giving everyone a "nice my process up" hack.

Yep.

But prior to 2.6.27(?) the same effect could be had by mmap()ing the
file with or without PROT_EXEC.  The patch restores a
probably-beneficial heuristic which got lost in the LRU rewrite.

So we're no worse than pre-2.6.27 kernels here.  Plus there are
probably more effective ways of getting that sort of boost, such as
having a process running which simply touches your favoured pages
at a suitable (and fairly low) frequency.
