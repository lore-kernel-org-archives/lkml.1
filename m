Return-Path: <linux-kernel-owner+w=401wt.eu-S932457AbZJ1AZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbZJ1AZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 20:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756917AbZJ1AZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 20:25:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43829 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904AbZJ1AZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 20:25:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Oct 2009 09:22:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       vedran.furac@gmail.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       rientjes@google.com
Subject: Re: [RFC][PATCH] oom_kill: avoid depends on total_vm and use real
 RSS/swap value for oom_score (Re: Memory overcommit
Message-Id: <20091028092251.8ddd1b20.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091027123810.GA22830@random.random>
References: <4ADE3121.6090407@gmail.com>
	<20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
	<4AE5CB4E.4090504@gmail.com>
	<20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com>
	<2f11576a0910262310g7aea23c0n9bfc84c900879d45@mail.gmail.com>
	<20091027153429.b36866c4.minchan.kim@barrios-desktop>
	<20091027153626.c5a4b5be.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262360910262355p3cac5c1bla4de9d42ea67fb4e@mail.gmail.com>
	<20091027164526.da6a23cb.kamezawa.hiroyu@jp.fujitsu.com>
	<20091027165612.4122d600.minchan.kim@barrios-desktop>
	<20091027123810.GA22830@random.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 13:38:10 +0100
Andrea Arcangeli <aarcange@redhat.com> wrote:

> On Tue, Oct 27, 2009 at 04:56:12PM +0900, Minchan Kim wrote:
> > Thanks for making the patch.
> > Let's hear other's opinion. :)
> 
> total_vm is nearly meaningless, especially on 64bit that reduces the
> mmap load on libs, I tried to change it to something "physical" (rss,
> didn't add swap too) some time ago too, not sure why I didn't manage
> to get it in. Trying again surely sounds good. Accounting swap isn't
> necessarily good, we may be killing a task that isn't accessing memory
> at all. So yes, we free swap but if the task is the "bloater" it's
> unlikely to be all in swap as it did all recent activity that lead to
> the oom. So I'm unsure if swap is good to account here, but surely I
> ack to replace virtual with rss. I would include the whole rss, as the
> file one may also be rendered unswappable if it is accessed in a loop
> refreshing the young bit all the time.
> 
I wonder I'll acccounting swap and export it via /proc/<pid>/??? file.
So, I'll divide this patch into 2 part as swap accounting/oom patch.

Considering amount of swap at oom isn't very bad, I think. But using the
same weight to rss and swap is not good, maybe.

Hmm, maybe
   anon_rss + file_rss/2 + swap_usage/4 + kosaki's time accounting change
can give us some better value. I'll consider what number is logical and
technically correct, again.

I'll prepare series of 2-4? patches.

Thanks,
-Kame


