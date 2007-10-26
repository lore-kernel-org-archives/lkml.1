Return-Path: <linux-kernel-owner+w=401wt.eu-S1765513AbXJZWcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765513AbXJZWcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756935AbXJZWcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:32:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbXJZWcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:32:03 -0400
Date: Fri, 26 Oct 2007 18:30:58 -0400
From: Rik van Riel <riel@redhat.com>
To: Martin Bligh <mbligh@mbligh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, marcelo@kvack.org,
       linux-kernel@vger.kernel.org, drepper@redhat.com, linux-mm@kvack.org
Subject: Re: OOM notifications
Message-ID: <20071026183058.7cef4e1b@bree.surriel.com>
In-Reply-To: <47226325.4000404@mbligh.org>
References: <20071018201531.GA5938@dmt>
	<20071026140201.ae52757c.akpm@linux-foundation.org>
	<472256AB.6060109@mbligh.org>
	<20071026141112.18af0fa6.akpm@linux-foundation.org>
	<20071026173550.333d8eb4@bree.surriel.com>
	<47226325.4000404@mbligh.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 14:59:01 -0700
Martin Bligh <mbligh@mbligh.org> wrote:

> Rik van Riel wrote:
> > On Fri, 26 Oct 2007 14:11:12 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> >> Sure, but in terms of high-level userspace interface, being able to
> >> select() on a group of priority buckets (spread across different
> >> nodes, zones and cgroups) seems a lot more flexible than any
> >> signal-based approach we could come up with.
> > 
> > Absolutely, the process needs to be able to just poll or
> > select on a file descriptor from the process main loop.
> > 
> > I am not convinced that the magic of NUMA memory distribution
> > and NUMA memory pressure should be visible to userspace.  Due
> > to the thundering herd problem we cannot wake up all of the
> > processes that select on the filedescriptor at the same time
> > anyway, so we can (later on) add NUMA magic to the process
> > selection logic in the kernel to only wake up processes on
> > the right NUMA nodes.
> > 
> > The initial patch probably does not need that.
> 
> Depends if you're using cpusets or not, I think?

The kernel knows on which cpuset a process can run.

The process itself may have been relocated to a different
cpuset at runtime, without it even knowing.

Because of that I think the magic of which process(es) to wake
up when there is memory pressure in some NUMA node should
live in the kernel.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
