Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbYKMArD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbYKMArD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 19:47:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYKMAqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 19:46:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbYKMAqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 19:46:52 -0500
Date: Wed, 12 Nov 2008 16:46:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, nishimura@mxp.nes.nec.co.jp,
       menage@google.com
Subject: Re: [RFC][PATCH 1/6] memcg: free all at rmdir
Message-Id: <20081112164637.b6f3cb78.akpm@linux-foundation.org>
In-Reply-To: <491B7395.8040606@linux.vnet.ibm.com>
References: <20081112122606.76051530.kamezawa.hiroyu@jp.fujitsu.com>
	<20081112122656.c6e56248.kamezawa.hiroyu@jp.fujitsu.com>
	<20081112160758.3dca0b22.akpm@linux-foundation.org>
	<491B7395.8040606@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 05:53:49 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Andrew Morton wrote:
> > On Wed, 12 Nov 2008 12:26:56 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> >> +5.1 on_rmdir
> >> +set behavior of memcg at rmdir (Removing cgroup) default is "drop".
> >> +
> >> +5.1.1 drop
> >> +       #echo on_rmdir drop > memory.attribute
> >> +       This is default. All pages on the memcg will be freed.
> >> +       If pages are locked or too busy, they will be moved up to the parent.
> >> +       Useful when you want to drop (large) page caches used in this memcg.
> >> +       But some of in-use page cache can be dropped by this.
> >> +
> >> +5.1.2 keep
> >> +       #echo on_rmdir keep > memory.attribute
> >> +       All pages on the memcg will be moved to its parent.
> >> +       Useful when you don't want to drop page caches used in this memcg.
> >> +       You can keep page caches from some library or DB accessed by this
> >> +       memcg on memory.
> > 
> > Would it not be more useful to implement a per-memcg version of
> > /proc/sys/vm/drop_caches?  (One without drop_caches' locking bug,
> > hopefully).
> > 
> > If we do this then we can make the above "keep" behaviour non-optional,
> > and the operator gets to choose whether or not to drop the caches
> > before doing the rmdir.
> > 
> > Plus, we get a new per-memcg drop_caches capability.  And it's a nicer
> > interface, and it doesn't have the obvious races which on_rmdir has,
> > etc.
> > 
> 
> Andrew, I suspect that will not be easy, since we don't track address spaces
> that belong to a particular memcg. If page cache ends up being shared across
> memcg's, dropping them would impact both mem cgroups.
> 

walk the LRUs?
