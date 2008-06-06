Return-Path: <linux-kernel-owner+w=401wt.eu-S932336AbYFFVJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbYFFVJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbYFFVJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:09:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbYFFVJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:09:05 -0400
Date: Fri, 6 Jun 2008 17:08:49 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 00/25] VM pageout scalability improvements (V10)
Message-ID: <20080606170849.1985f0f3@bree.surriel.com>
In-Reply-To: <20080606140216.f4520f40.akpm@linux-foundation.org>
References: <20080606202838.390050172@redhat.com>
	<20080606140216.f4520f40.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 14:02:16 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 06 Jun 2008 16:28:38 -0400
> Rik van Riel <riel@redhat.com> wrote:
> 
> > On large memory systems, the VM can spend way too much time scanning
> > through pages that it cannot (or should not) evict from memory. Not
> > only does it use up CPU time, but it also provokes lock contention
> > and can leave large systems under memory presure in a catatonic state.
> > 
> > Against 2.6.26-rc2-mm1
> > 
> > This patch series improves VM scalability by:
> 
> -mm has a patch called
> vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
> which has been sitting there for some time waiting for us to work out
> whether or not it is a desirable thing.
> 
> This patchset of yours apparently retains the change which
> vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
> makes.
> 
> But do we know that it was a good one?

Benchmark results here indicate that it helps some workloads by up
to 10%, but makes the page cache pages that fall off of the active
list more prone to being replaced by streaming IO.

I have added in a fix in this series to set the referenced bit on
unmapped page cache pages that get deactivated, so that defect is
resolved.

I've been busy with some other stuff this week;  I'll try to get
you some numbers ASAP.

-- 
All rights reversed.
