Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab0CKJPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:15:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:55489 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab0CKJPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:15:04 -0500
Subject: Re: [PATCH -mmotm 0/5] memcg: per cgroup dirty limit (v6)
From: Peter Zijlstra <peterz@infradead.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Righi <arighi@develer.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Vivek Goyal <vgoyal@redhat.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20100311101726.f58d24e9.kamezawa.hiroyu@jp.fujitsu.com>
References: <1268175636-4673-1-git-send-email-arighi@develer.com>
	 <20100311093913.07c9ca8a.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100311101726.f58d24e9.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Mar 2010 10:14:25 +0100
Message-ID: <1268298865.5279.997.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 10:17 +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 11 Mar 2010 09:39:13 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > The performance overhead is not so huge in both solutions, but the impact on
> > > performance is even more reduced using a complicated solution...
> > > 
> > > Maybe we can go ahead with the simplest implementation for now and start to
> > > think to an alternative implementation of the page_cgroup locking and
> > > charge/uncharge of pages.

FWIW bit spinlocks suck massive.

> > 
> > maybe. But in this 2 years, one of our biggest concerns was the performance.
> > So, we do something complex in memcg. But complex-locking is , yes, complex.
> > Hmm..I don't want to bet we can fix locking scheme without something complex.
> > 
> But overall patch set seems good (to me.) And dirty_ratio and dirty_background_ratio
> will give us much benefit (of performance) than we lose by small overheads.

Well, the !cgroup or root case should really have no performance impact.

> IIUC, this series affects trgger for background-write-out.

Not sure though, while this does the accounting the actual writeout is
still !cgroup aware and can definately impact performance negatively by
shrinking too much.
