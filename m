Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbZFVPk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbZFVPk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbZFVPkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:40:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55867 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbZFVPkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:40:17 -0400
Date: Mon, 22 Jun 2009 11:39:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 15/20] io-controller: map async requests to appropriate
	cgroup
Message-ID: <20090622153910.GB15600@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-16-git-send-email-vgoyal@redhat.com> <4A3EE245.7030409@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3EE245.7030409@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 09:45:41AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > o So far we were assuming that a bio/rq belongs to the task who is submitting
> >   it. It did not hold good in case of async writes. This patch makes use of
> >   blkio_cgroup pataches to attribute the aysnc writes to right group instead
> >   of task submitting the bio.
> > 
> > o For sync requests, we continue to assume that io belongs to the task
> >   submitting it. Only in case of async requests, we make use of io tracking
> >   patches to track the owner cgroup.
> > 
> > o So far cfq always caches the async queue pointer. With async requests now
> >   not necessarily being tied to submitting task io context, caching the
> >   pointer will not help for async queues. This patch introduces a new config
> >   option CONFIG_TRACK_ASYNC_CONTEXT. If this option is not set, cfq retains
> >   old behavior where async queue pointer is cached in task context. If it
> >   is not set, async queue pointer is not cached and we take help of bio
> 
> Here "If it is not set" should be "If it is set".

Yes, in last line it should be "If it is set". Thanks Gui. Will fix the
comment.

Vivek
