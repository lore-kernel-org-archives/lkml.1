Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZKCUYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZKCUYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 15:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbZKCUYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 15:24:05 -0500
Received: from smtp-out.google.com ([216.239.33.17]:45434 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbZKCUYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 15:24:04 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=tDW+NT3dmv2zqQtP0lEmsRy4hnr4//QUvsG6SfM3+ngg0VNGNmZcvU5C67heYS7lp
	sJbb7Hk3mNQ+YGzNBDd4A==
Date: Tue, 3 Nov 2009 12:24:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, minchan.kim@gmail.com,
       vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [RFC][-mm][PATCH 3/6] oom-killer: count lowmem rss
In-Reply-To: <20091102162617.9d07e05f.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0911031220170.25890@chino.kir.corp.google.com>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com> <20091102162617.9d07e05f.kamezawa.hiroyu@jp.fujitsu.com>
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
> Count lowmem rss per mm_struct. Lowmem here means...
> 
>    for NUMA, pages in a zone < policy_zone.
>    for HIGHMEM x86, pages in NORMAL zone.
>    for others, all pages are lowmem.
> 
> Now, lower_zone_protection[] works very well for protecting lowmem but
> possiblity of lowmem-oom is not 0 even if under good protection in the kernel.
> (As fact, it's can be configured by sysctl. When we keep it high, there
>  will be tons of not-for-use memory but system will be protected against
>  rare event of lowmem-oom.)

Right, lowmem isn't addressed currently by the oom killer.  Adding this 
constraint will probably make the heuristics much harder to write and 
understand.  It's not always clear that we want to kill a task using 
lowmem just because another task needs some, for instance.  Do you think 
we'll need a way to defer killing any task is no task is heuristically 
found to be hogging lowmem?
