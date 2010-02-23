Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310Ab0BWIRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 03:17:40 -0500
Received: from smtp-out.google.com ([216.239.33.17]:2501 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab0BWIRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 03:17:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=jW2FvlAo0YbNJXvmgm0RNwGyqOyGLzajGSduGu2TBN8Xf+Kmc8TJdhZjXoPryPg6u
	sLmqsitdntTOQuVqyIHzQ==
Date: Tue, 23 Feb 2010 00:17:26 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 3/9 v2] oom: select task from tasklist for mempolicy
 ooms
In-Reply-To: <20100223063129.GI3063@balbir.in.ibm.com>
Message-ID: <alpine.DEB.2.00.1002230014570.5842@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com> <alpine.DEB.2.00.1002151418030.26927@chino.kir.corp.google.com> <20100223063129.GI3063@balbir.in.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010, Balbir Singh wrote:

> > The oom killer presently kills current whenever there is no more memory
> > free or reclaimable on its mempolicy's nodes.  There is no guarantee that
> > current is a memory-hogging task or that killing it will free any
> > substantial amount of memory, however.
> > 
> > In such situations, it is better to scan the tasklist for nodes that are
> > allowed to allocate on current's set of nodes and kill the task with the
> > highest badness() score.  This ensures that the most memory-hogging task,
> > or the one configured by the user with /proc/pid/oom_adj, is always
> > selected in such scenarios.
> > 
> > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> Seems reasonable, but I think it will require lots of testing.

I already tested it by checking that tasks with very elevated oom_adj 
values don't get killed when they do not share the same MPOL_BIND nodes as 
a memory-hogging task.

What additional testing did you have in mind?
