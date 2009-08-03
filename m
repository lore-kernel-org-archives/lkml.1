Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbZHCMM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbZHCMM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbZHCMM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:12:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35946 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbZHCMM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:12:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20090803200639.CC1D.A69D9226@jp.fujitsu.com>
References: <alpine.DEB.2.00.0907310210460.25447@chino.kir.corp.google.com> <20090803200639.CC1D.A69D9226@jp.fujitsu.com>
Message-Id: <20090803211112.CC23.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  3 Aug 2009 21:12:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One mistake.

> > > And, May I explay why I think your oom_adj_child is wrong idea?
> > > The fact is: new feature introducing never fix regression. yes, some
> > > application use new interface and disappear the problem. but other
> > > application still hit the problem. that's not correct development style
> > > in kernel.
> > > 
> > 
> > So you're proposing that we forever allow /proc/pid/oom_score to be 
> > completely wrong for pid without any knowledge to userspace?  That we 
> > falsely advertise what it represents and allow userspace to believe that 
> > changing oom_adj for a thread sharing memory with other threads actually 
> > changes how the oom killer selects tasks?
> 
> No. perhaps no doublly.
> 
> 1) In my patch, oom_score is also per-process value. all thread have the same
>    oom_score.
>    It's clear meaning.

it's wrong explanation. oom_score is calculated from the same oom_adj.
but it have each different oom_score. sorry my confused.



> 2) In almost case, oom_score display collect value because oom_adj is per-process
>    value too. 
>    Yes, there is one exception. vfork() and change oom_adj'ed process might display 
>    wrong value. but I don't think it is serious problem because vfork() process call
>    exec() soon.
>    Administrator never recognize this difference.
> 
> > Please.
> 
> David, I hope you join to fix this regression. I can't believe we
> can't fix this issue honestly.
> 
> 
> 



