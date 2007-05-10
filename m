Return-Path: <linux-kernel-owner+w=401wt.eu-S1762415AbXEJXJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762415AbXEJXJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758760AbXEJXJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:09:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758570AbXEJXJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:09:30 -0400
Message-ID: <4643A616.3090202@redhat.com>
Date: Thu, 10 May 2007 16:09:10 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: getcpu after sched_setaffinity
References: <46439BBA.2070705@redhat.com> <20070510234446.GC2012@bingen.suse.de>
In-Reply-To: <20070510234446.GC2012@bingen.suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Probably. In principle getcpu() (where does the sched_ come from btw?)

getcpu() is an unacceptable name.  All te other functions dealing with 
CPU (sets, etc) have a sched_ prefix.


> is only designed for the case where you don't set the affinity explicitely;
> otherwise you should already know where you are and don't need it.

That's not true in general.  Yes, because I want to test vgetcpu() I 
restrict the set to just one CPU.

But if I have more than 2 "CPUs" and I set the affinity to two CPUs 
which currently are not used you cannot make this argument.

getcpu should always work correctly not only if you cannot determine it 
in another way.


> Hmm ok one could probably define memset(..., 0) as a invalidation
> interface, but because of the considerations above i don't think
> it is really needed.

It is needed.

For now I added the cache clearing in the setaffinity calls in libc. 
Resetting to cache to {0,0} seems to work.

-- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
