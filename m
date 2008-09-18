Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbYIQHxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbYIQHxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 03:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYIQHxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 03:53:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50532 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbYIQHxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 03:53:11 -0400
Date: Fri, 19 Sep 2008 04:52:12 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH -mm 2/2] cgroup: use multibuf for tasks file
Cc: kosaki.motohiro@jp.fujitsu.com, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <48CF2863.1010502@cn.fujitsu.com>
References: <48CF1710.20907@cn.fujitsu.com> <48CF2863.1010502@cn.fujitsu.com>
Message-Id: <20080919044828.00FA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Li Zefan wrote:
> > Lai Jiangshan wrote:
> >> Paul Menage wrote:
> >>> On Fri, Sep 12, 2008 at 4:55 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> >>>> when we open a really large cgroup for read, we may failed
> >>>> for kmalloc() is not reliable for allocate a big buffer.
> >>> This still depends on an answer to whether using plain vmalloc is too
> >>> much overhead.
> >>>
> >>> Balbir pointed out to me that most cgroups are likely to be pretty
> >>> small - so the solution of just doing a kmalloc() for 8K or less, and
> >>> a vmalloc() for more than 8K (which is >2000 threads) will avoid the
> >>> vmalloc overhead in almost all cases; the question is whether
> >>> eliminating the remaining overhead is worth the extra complexity.
> >>>
> >> I think open cgroup.tasks to read is not a critical path.
> >> so using plain vmalloc(even more overhead functions) is worth.
> >>
> > 
> > This patch does not only add runtime overhead, but also make code much more
> > complex, so the code is harder to read and harder to maintain, and object size
> > is increased, which means increased memory footprint.
> > 
> > And is there any reason not using plain vmalloc? Don't bloat the kernel without
> > good reasons IMO...
> > 
> 
> I said that vmalloc is worth.
> vmalloc was the fist choice of my opinion. ^_^

I agreed with Paul Menage's opinion because ..

 - plain vmalloc cause unnecessary overhead.
 - vmalloc sholdn't use for small allocation
   because virtual address space is valuable resource on 32bit machine.



