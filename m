Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbZI1BXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbZI1BXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 21:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZI1BXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 21:23:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43369 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZI1BXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 21:23:35 -0400
Date: Mon, 28 Sep 2009 03:23:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 02/12] Immediate Values - Architecture Independent Code
Message-ID: <20090928012337.GC1656@one.firstfloor.org>
References: <20090924132626.485545323@polymtl.ca> <20090924133359.218934235@polymtl.ca> <20090924212013.d27226c4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924212013.d27226c4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 09:20:13PM -0700, Andrew Morton wrote:
> On Thu, 24 Sep 2009 09:26:28 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Immediate values are used as read mostly variables that are rarely updated. They
> > use code patching to modify the values inscribed in the instruction stream. It
> > provides a way to save precious cache lines that would otherwise have to be used
> > by these variables.
> 
> What a hare-brained concept.

The concept makes a lot of sense. Cache misses are extremly costly
on modern CPUs and when the workload has blown the caches away in user space
it can literally be hundreds or even thousands of cycles to fetch
a data cache line.

Similar optimizations are also quite common in compilers (with 
profile feedback) and JITs.

> Do you have any data which indicates that this thing is of any real
> benefit to anyone for anything?

There's a lot of data around that the kernel has very little IPC
due to a lot of cache misses in some workloads. In general this applies
to anything that touches a lot of data in user space and blows
the caches away.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
