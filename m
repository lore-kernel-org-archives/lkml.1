Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756904AbYLQBST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbYLQBST (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 20:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYLQBSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 20:18:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59347 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbYLQBSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 20:18:03 -0500
Message-ID: <494852FA.3000101@cn.fujitsu.com>
Date: Wed, 17 Dec 2008 09:16:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make cgroup_path() RCU-safe
References: <6599ad830812161558t4da0e5e7l4ad7d6f3a0dfbe6e@mail.gmail.com>
In-Reply-To: <6599ad830812161558t4da0e5e7l4ad7d6f3a0dfbe6e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Make cgroup_path() RCU safe
> 
> This patch fixes races between /proc/sched_debug by freeing
> cgroup objects via an RCU callback. Thus any cgroup reference obtained
> from an RCU-safe source will remain valid during the RCU section. Since
> dentries are also RCU-safe, this allows us to traverse up the tree safely.
> 
> Additionally, make cgroup_path() check for a NULL cgrp->dentry to avoid
> trying to report a path for a partially-created cgroup.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 

Thanks!

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Tested-by: Li Zefan <lizf@cn.fujitsu.com>

But the patch is word wrapped..

> --
> 
> There are more RCU changes that I can make for 2.6.29+, but this
> should fix the problem in 2.6.28

...

> +/*
> + * cgroup_path() fills in a filesystem-like path for the given cgroup
> + * into "buf", up to "buflen" characters. Should be called with
> + * cgroup_mutex held, or else in an RCU section with an RCU-protected
> + * cgroup reference
> + */

minor comment:

We already have kernel-doc for cgroup_path(), why do we need those comments
in cgroup.h.

>  int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
> 
