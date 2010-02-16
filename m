Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab0BPJKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 04:10:54 -0500
Received: from smtp-out.google.com ([216.239.33.17]:14744 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab0BPJKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 04:10:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=QJEGtzjxpplmCZ0WAAiJStAUTxnjFG4j/SgpFxUVgYPEk3VJXPPA3TAy4632q4gvy
	GZGhUvtdG1tuXKGXilpGA==
Date: Tue, 16 Feb 2010 01:10:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 1/7 -mm] oom: filter tasks not sharing the same cpuset
In-Reply-To: <20100216090408.GL5723@laptop>
Message-ID: <alpine.DEB.2.00.1002160105320.17122@chino.kir.corp.google.com>
References: <20100215115154.727B.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1002151401280.26927@chino.kir.corp.google.com> <20100216110859.72C6.A69D9226@jp.fujitsu.com> <20100216070344.GF5723@laptop> <alpine.DEB.2.00.1002160047340.17122@chino.kir.corp.google.com>
 <20100216090408.GL5723@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, Nick Piggin wrote:

> I don't really agree with your black and white view. We equally
> can't tell a lot of cases about who is pinning memory where. The
> fact is that any task can be pinning memory and the heuristic
> was specifically catering for that.
> 

That's a main source of criticism of the current heuristic: it needlessly 
kills tasks.  There is only one thing we know for certain: current is 
trying to allocate memory on its nodes.  We can either kill a task that 
is allowed that same set or current itself; there's no evidence that 
killing anything else will lead to memory freeing that will allow the 
allocation to succeed.  The heuristic will never perfectly select the task 
that it should kill 100% of the time when playing around with mempolicy 
nodes or cpuset mems, but relying on their current placement is a good 
indicator of what is more likely than not to free memory of interest.
