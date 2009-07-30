Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbZG3JbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbZG3JbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 05:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZG3JbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 05:31:16 -0400
Received: from smtp-out.google.com ([216.239.33.17]:17277 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZG3JbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 05:31:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=OK/MUjbpds2mdFmXjtwbXDGLERNY1XRe3+tj93k/cXrHs7kDd0QAIZu4oRe2ETRTD
	4THicYtcS5DIQDUyhiO4g==
Date: Thu, 30 Jul 2009 02:31:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Paul Menage <menage@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
In-Reply-To: <20090730180029.c4edcc09.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907300219580.13674@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907282125260.554@chino.kir.corp.google.com> <20090730180029.c4edcc09.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009, KAMEZAWA Hiroyuki wrote:

> 1. IIUC, the name is strange.
> 
> At job scheduler, which does this.
> 
> if (vfork() == 0) {
> 	/* do some job */
> 	execve(.....)
> }
> 
> Then, when oom_adj_child can be effective is after execve().
> IIUC, the _child_ means a process created by vfork().
> 

It's certainly a difficult thing to name and I don't claim that "child" is 
completely accurate since, as you said, vfork'd tasks are also children 
of the parent yet they share the same oom_adj value since it's an 
attribute of the shared mm.

If you have suggestions for a better name, I'd happily ack it.

> 2. More simple plan is like this, IIUC.
> 
>   fix oom-killer's select_bad_process() not to be in deadlock.
> 

Alternate ideas?

> rather than this new stupid interface.
> 

Well, thank you.  Regardless of whether you think it's stupid or not, it 
doesn't allow you to livelock the kernel in a very trivial way when the 
oom killer gets invoked prior to execve() and the parent is OOM_DISABLE.
