Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbZKDA2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbZKDA2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbZKDA2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:28:07 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39133 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZKDA2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:28:06 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 4 Nov 2009 09:25:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, minchan.kim@gmail.com,
       vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [RFC][-mm][PATCH 5/6] oom-killer: check last total_vm expansion
Message-Id: <20091104092534.626a2352.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0911031224270.25890@chino.kir.corp.google.com>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com>
	<20091102162837.405783f3.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911031224270.25890@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 12:29:39 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Mon, 2 Nov 2009, KAMEZAWA Hiroyuki wrote:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > At considering oom-kill algorithm, we can't avoid to take runtime
> > into account. But this can adds too big bonus to slow-memory-leaker.
> > For adding penalty to slow-memory-leaker, we record jiffies of
> > the last mm->hiwater_vm expansion. That catches processes which leak
> > memory periodically.
> > 
> 
> No, it doesn't, it simply measures the last time the hiwater mark was 
> increased.  That could have increased by a single page in the last tick 
> with no increase in memory consumption over the past year and then its 
> unfairly biased against for quiet_time in the new oom kill heuristic 
> (patch 6).  Using this as part of the badness scoring is ill conceived 
> because it doesn't necessarily indicate a memory leaking task, just one 
> that has recently allocated memory.

Hmm. Maybe I can rewrite this as "periodic expansion have done or not" code.
Okay, this patch itself will be dropped.

If you find better algorithm, let me know.

Thanks,
-Kame

