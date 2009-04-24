Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbZDXPMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbZDXPMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 11:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZDXPLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 11:11:51 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:34682 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbZDXPLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 11:11:50 -0400
Date: Fri, 24 Apr 2009 20:40:51 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>, Andrea Righi <righi.andrea@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, Paul Menage <menage@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] ext3: do not throttle metadata and journal IO
Message-ID: <20090424151051.GF3944@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-10-git-send-email-righi.andrea@gmail.com> <20090417123805.GC7117@mit.edu> <20090417125004.GY4593@kernel.dk> <20090417143903.GA30365@linux> <20090421001822.GB19186@mit.edu> <20090421083001.GA8441@linux> <20090421140631.GF19186@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090421140631.GF19186@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Theodore Tso <tytso@mit.edu> [2009-04-21 10:06:31]:

> On Tue, Apr 21, 2009 at 10:30:02AM +0200, Andrea Righi wrote:
> > 
> > We're trying to address also this issue, setting max dirty pages limit
> > per cgroup, and force a direct writeback when these limits are exceeded.
> > 
> > In this case dirty ratio throttling should happen automatically because
> > the process will be throttled by the IO controller when it tries to
> > writeback the dirty pages and submit IO requests.
> 
> The challenge here will be the accounting; consider that you may have
> a file that had some of its pages in its page cache dirtied by a
> process in cgroup A.  Now another process in cgroup B dirties some
> more pages.  This could happen either via a mmap'ed file or via the
> standard read/write system calls.  How do you track which dirty pages
> should be charged against which cgroup?

We have ways to track the cgroup from either "mm_struct" or the
"page". Given the context, vma or mm, we should be able to charge the
page to the cgroup, undoing the charge might be challenge since we'll
need to figure out whom to uncharge from the write context. This needs
some investigation. We could even decay the charge or use similar
techniques, don't know yet.

-- 
	Balbir
