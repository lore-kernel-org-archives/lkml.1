Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbZKCU3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbZKCU3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 15:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZKCU3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 15:29:42 -0500
Received: from smtp-out.google.com ([216.239.33.17]:46426 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZKCU3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 15:29:41 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=DQzAJ/sH0xdlT5MjbHIWrrnmnWvzLyb86/OoJIngRHC5PVcyG6RhEJOfYh8A4JsKM
	ev7m+U6lirbWW6CcM3WOg==
Date: Tue, 3 Nov 2009 12:29:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, minchan.kim@gmail.com,
       vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [RFC][-mm][PATCH 5/6] oom-killer: check last total_vm
 expansion
In-Reply-To: <20091102162837.405783f3.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0911031224270.25890@chino.kir.corp.google.com>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com> <20091102162837.405783f3.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009, KAMEZAWA Hiroyuki wrote:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> At considering oom-kill algorithm, we can't avoid to take runtime
> into account. But this can adds too big bonus to slow-memory-leaker.
> For adding penalty to slow-memory-leaker, we record jiffies of
> the last mm->hiwater_vm expansion. That catches processes which leak
> memory periodically.
> 

No, it doesn't, it simply measures the last time the hiwater mark was 
increased.  That could have increased by a single page in the last tick 
with no increase in memory consumption over the past year and then its 
unfairly biased against for quiet_time in the new oom kill heuristic 
(patch 6).  Using this as part of the badness scoring is ill conceived 
because it doesn't necessarily indicate a memory leaking task, just one 
that has recently allocated memory.
