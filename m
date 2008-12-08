Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbYLHVd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbYLHVd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 16:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYLHVds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 16:33:48 -0500
Received: from waste.org ([66.93.16.53]:37875 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbYLHVdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 16:33:47 -0500
Subject: Re: [PATCH] - support inheritance of mlocks across fork/exec V2
From: Matt Mackall <mpm@selenic.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel <linux-kernel@vger.kernel.org>, riel@redhat.com,
       hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com,
       linux-api@vger.kernel.org
In-Reply-To: <1228770337.31442.44.camel@lts-notebook>
References: <1227561707.6937.61.camel@lts-notebook>
	 <20081125152651.b4c3c18f.akpm@linux-foundation.org>
	 <1228331069.6693.73.camel@lts-notebook>
	 <20081206220729.042a926e.akpm@linux-foundation.org>
	 <1228770337.31442.44.camel@lts-notebook>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 15:33:05 -0600
Message-Id: <1228771985.3726.32.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-08 at 16:05 -0500, Lee Schermerhorn wrote:
> > > In support of a "lock prefix command"--e.g., mlock <cmd>
> <args> ...
> > > Analogous to taskset(1) for cpu affinity or numactl(8) for numa memory
> > > policy.
> > > 
> > > Together with patches to keep mlocked pages off the LRU, this will
> > > allow users/admins to lock down applications without modifying them,
> > > if their RLIMIT_MEMLOCK is sufficiently large, keeping their pages
> > > off the LRU and out of consideration for reclaim.
> > > 
> > > Potentially useful, as well, in real-time environments to force
> > > prefaulting and residency for applications that don't mlock themselves.

This is a bit scary to me. Privilege and mode inheritance across
processes is the root of many nasty surprises, security and otherwise. 

Here's a crazy alternative: add a flag to containers instead? I think
this is a better match to what you're trying to do and will keep people
from being surprised when an mlockall call in one thread causes a
fork/exec in another thread to crash their box, but only sometimes.

-- 
Mathematics is the supreme nostalgia of our time.

