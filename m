Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbZJ0Ss3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbZJ0Ss3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 14:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756304AbZJ0Ss2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 14:48:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635AbZJ0Ss2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 14:48:28 -0400
Date: Tue, 27 Oct 2009 19:47:43 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       vedran.furac@gmail.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rientjes@google.com
Subject: Re: [RFC][PATCH] oom_kill: avoid depends on total_vm and use real
 RSS/swap value for oom_score (Re: Memory overcommit
Message-ID: <20091027184743.GD5753@random.random>
References: <4ADE3121.6090407@gmail.com>
 <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
 <4AE5CB4E.4090504@gmail.com>
 <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com>
 <2f11576a0910262310g7aea23c0n9bfc84c900879d45@mail.gmail.com>
 <20091027153429.b36866c4.minchan.kim@barrios-desktop>
 <20091027153626.c5a4b5be.kamezawa.hiroyu@jp.fujitsu.com>
 <28c262360910262355p3cac5c1bla4de9d42ea67fb4e@mail.gmail.com>
 <20091027164526.da6a23cb.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0910271821130.11372@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910271821130.11372@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 06:39:07PM +0000, Hugh Dickins wrote:
> OOM (physical memory) decisions on total_vm (virtual memory) has
> seemed weird, so it's well worth trying this approach.  Whether swap

It is weird and wrong, I strongly support fixing it once and for
all. The oom killing should be based on physical info, total_vm is
a very rough approximation of the real info we're interested about
(real RAM utilization of the task).

> should be included along with rss isn't quite clear to me: I'm not
> saying you're wrong, not at all, just that it's not quite obvious.

Agreed it's not obvious. Intuitively I think only including RSS and no
swap is best, but clearly I can't be entirely against including swap
too as there may be scenarios where including swap provides for a
better choice.

My argument for not including swap is that we kill tasks to free RAM
(we don't really care to free swap, system needs RAM at oom time).
Freeing swap won't immediately help because no RAM is freed when swap
is released (sure other tasks that sits huge in RAM can be moved to
swap after swap isn't full but if we immediately killed those tasks
that were huge in RAM in the first place we'd be better off).

> I've several observations to make about bad OOM kill decisions,
> but it's probably better that I make them in the original
> "Memory overcommit" thread, rather than divert this thread.

:)
