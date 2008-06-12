Return-Path: <linux-kernel-owner+w=401wt.eu-S1761386AbYFLNc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbYFLNc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759657AbYFLNcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:32:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759452AbYFLNcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:32:17 -0400
Date: Thu, 12 Jun 2008 09:31:21 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm 00/24] VM pageout scalability improvements (V12)
Message-ID: <20080612093121.586f09c6@bree.surriel.com>
In-Reply-To: <20080611223430.cba0f1b6.akpm@linux-foundation.org>
References: <20080611184214.605110868@redhat.com>
	<20080611223430.cba0f1b6.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 22:34:30 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On a 900MB 2-way, allocate and memset 1000MB.

> Seems to have saved a little CPU but the IO patterns got worse.

In previous tests on my 16GB system, a 16GB fillmem (goes into swap)
saves enough CPU time to make up for potentially worse detection of
the working set (well, not like this program really has a working set).

I'll try this out myself on a smaller system and see if there's
something I can do to make it better.
 
> qsbench, 4 processes, memory size tuned to threshold-of-swapping*1.1:
> 
> Mainline:
> 
> vmm:/home/akpm/qsbench> time ./qsbench -p 4 -m 230
> ./qsbench -p 4 -m 230  175.45s user 45.67s system 60% cpu 6:08.40 total
> 
> 2.6.26-rc5-mm3:
> 
> vmm:/home/akpm/qsbench> time ./qsbench -p 4 -m 230
> ./qsbench -p 4 -m 230  178.21s user 28.49s system 99% cpu 3:27.14 total
> 
> So woot!  Professional qsbench users will be pleased ;) It could have
> been a fluke though - iirc qsbench is pretty unstable, especially on
> the threshold.

Ignoring references that happen on the active list, only acting
on re-references that happen on the inactive list, gives anonymous
memory something that closer resembles the use-once policy.

Better for some workloads, but potentially worse for others.

Definately worth tweaking the system though, to get performance
as close to where we want it as possible :)

> Main thing is: it seems stable.  Old LTP ran for an hour or so before I
> hit the msgctl08 crash (which is a regression in current mainline).

Our main focus has been on stability for the past few months,
trying to get the whole series integrated.

-- 
All rights reversed.
