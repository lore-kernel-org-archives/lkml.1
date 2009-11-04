Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbZKDAYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbZKDAYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbZKDAYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:24:53 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36713 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbZKDAYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:24:52 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 4 Nov 2009 09:22:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, minchan.kim@gmail.com,
       vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [RFC][-mm][PATCH 3/6] oom-killer: count lowmem rss
Message-Id: <20091104092213.02f27075.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0911031220170.25890@chino.kir.corp.google.com>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com>
	<20091102162617.9d07e05f.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911031220170.25890@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 12:24:01 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Mon, 2 Nov 2009, KAMEZAWA Hiroyuki wrote:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Count lowmem rss per mm_struct. Lowmem here means...
> > 
> >    for NUMA, pages in a zone < policy_zone.
> >    for HIGHMEM x86, pages in NORMAL zone.
> >    for others, all pages are lowmem.
> > 
> > Now, lower_zone_protection[] works very well for protecting lowmem but
> > possiblity of lowmem-oom is not 0 even if under good protection in the kernel.
> > (As fact, it's can be configured by sysctl. When we keep it high, there
> >  will be tons of not-for-use memory but system will be protected against
> >  rare event of lowmem-oom.)
> 
> Right, lowmem isn't addressed currently by the oom killer.  Adding this 
> constraint will probably make the heuristics much harder to write and 
> understand.  It's not always clear that we want to kill a task using 
> lowmem just because another task needs some, for instance.
The same  can be said against all oom-kill ;)

> Do you think we'll need a way to defer killing any task is no task is
> heuristically found to be hogging lowmem?

Yes, I think so. But my position is a bit different.

In typical x86-32 server case, which has 4-8G memory, most of memory usage
is highmem. So, if we have no knowledge of lowmem, multiple innocent processes
will be killed in every 30 secs of oom-kill. 

My final goal is migrating lowmem pages to highmem as kswapd-migraion or
oom-migration. Total rewrite for this will be required in future.

Thanks,
-Kame




Thanks,
-Kame



Thanks,
-Kame

