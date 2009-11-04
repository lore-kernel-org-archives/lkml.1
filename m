Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbZKDDWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbZKDDWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 22:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbZKDDWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 22:22:33 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47206 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbZKDDWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 22:22:32 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 4 Nov 2009 12:19:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
Message-Id: <20091104121952.07ea695a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0911031905390.11790@chino.kir.corp.google.com>
References: <hav57c$rso$1@ger.gmane.org>
	<alpine.DEB.2.00.0910272205200.7507@chino.kir.corp.google.com>
	<20091028150536.674abe68.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910272311001.15462@chino.kir.corp.google.com>
	<20091028152015.3d383cd6.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910290136000.11476@chino.kir.corp.google.com>
	<4AE97861.1070902@gmail.com>
	<alpine.DEB.2.00.0910291248480.2276@chino.kir.corp.google.com>
	<20091030084836.5428e085.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0910300200170.18076@chino.kir.corp.google.com>
	<20091030183638.1125c987.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911031240470.29695@chino.kir.corp.google.com>
	<20091104095021.5532e913.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911031752180.1187@chino.kir.corp.google.com>
	<20091104111703.b46ae72b.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911031905390.11790@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 19:10:34 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 4 Nov 2009, KAMEZAWA Hiroyuki wrote:
> 
> > My point and your point are differnt.
> > 
> >   1. All my concern is "baseline for heuristics"
> >   2. All your concern is "baseline for knob, as oom_adj"
> > 
> > ok ? For selecting victim by the kernel, dynamic value is much more useful.
> > Current behavior of "Random kill" and "Kill multiple processes" are too bad.
> > Considering oom-killer is for what, I think "1" is more important.
> > 
> > But I know what you want, so, I offers new knob which is not affected by RSS
> > as I wrote in previous mail.
> > 
> > Off-topic:
> > As memcg is growing better, using OOM-Killer for resource control should be
> > ended, I think. Maybe Fake-NUMA+cpuset is working well for google system, 
> > but plz consider to use memcg. 
> > 
> 
> I understand what you're trying to do, and I agree with it for most 
> desktop systems.  However, I think that admins should have a very strong 
> influence in what tasks the oom killer kills.  It doesn't really matter if 
> it's via oom_adj or not, and its debatable whether an adjustment on a 
> static heuristic score is in our best interest in the first place.  But we 
> must have an alternative so that our control over oom killing isn't lost.
> 
I'll not go too quickly, so, let's discuss and rewrite patches more, later.
I'll parepare new version in the next week. For this week, I'll post
swap accounting and improve fork-bomb detector.

> I'd also like to open another topic for discussion if you're proposing 
> such sweeping changes: at what point do we allow ~__GFP_NOFAIL allocations 
> to fail even if order < PAGE_ALLOC_COSTLY_ORDER and defer killing 
> anything?  We both agreed that it's not always in the best interest to 
> kill a task so that an allocation can succeed, so we need to define some 
> criteria to simply fail the allocation instead.
> 
Yes, I think allocation itself (> order=0) should fail more before we finally
invoke OOM. It tends to be soft-landing rather than oom-killer.

Thanks,
-Kame

