Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbYLOLKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbYLOLKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 06:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYLOLJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 06:09:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48040 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbYLOLJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 06:09:51 -0500
Date: Mon, 15 Dec 2008 20:08:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
Message-Id: <20081215200849.94b1b8de.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1229337829.14605.41.camel@twins>
References: <494234B0.5@cn.fujitsu.com>
	<20081212100044.GB18152@elte.hu>
	<4944754F.8050503@cn.fujitsu.com>
	<1229258890.17130.9.camel@lappy.programming.kicks-ass.net>
	<4945B200.7020207@cn.fujitsu.com>
	<1229328783.14605.11.camel@twins>
	<49462890.1040002@cn.fujitsu.com>
	<1229337829.14605.41.camel@twins>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2008 11:43:49 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > +                if (cgroup_is_removed(cgroup) || !cgroup->dentry)
> > +                        return;
> >  		cgroup_path(cgroup, path, sizeof(path));
> > +	}
> 
> Perhaps wrap that check in a cgroup_*() helper? That would avoid the
> duplication, be clearer and not open code the ->dentry assumption.
> 
> cgroup_is_active() perhaps?
> 

I vote for cgroup_is_populated().

Thx,
-Kame

