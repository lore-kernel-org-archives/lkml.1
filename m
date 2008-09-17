Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbYIQUuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbYIQUuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 16:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbYIQUuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 16:50:03 -0400
Received: from waste.org ([66.93.16.53]:38589 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbYIQUuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 16:50:01 -0400
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20080917131419.e6b7622e.akpm@linux-foundation.org>
References: <1221046892.30429.85.camel@twins.programming.kicks-ass.net>
	 <20080910114755.GA9696@elte.hu> <20080910121217.GA16013@elte.hu>
	 <20080910144812.GB18644@wotan.suse.de>
	 <1221058864.30429.291.camel@twins.programming.kicks-ass.net>
	 <20080910152651.GE18644@wotan.suse.de> <20080911082709.GA14378@elte.hu>
	 <20080914073906.GA6184@elte.hu>
	 <20080914004442.4f8e851f.akpm@linux-foundation.org>
	 <20080914080631.GA10720@elte.hu> <20080914221231.GG27080@wotan.suse.de>
	 <20080917131419.e6b7622e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 17 Sep 2008 13:46:42 -0700
Message-Id: <1221684402.3077.15.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-09-17 at 13:14 -0700, Andrew Morton wrote:
> On Mon, 15 Sep 2008 00:12:31 +0200
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > tiny-shmem calls do_truncate in shmem_file_setup. do_truncate takes i_mutex,
> > and shmem_file_setup is called with mmap_sem held. However i_mutex nests
> > outside mmap_sem.
> > 
> > Copy the code in shmem.c to avoid this problem.
> > 
> 
> It's a bit unfortunate (as in: arse-about) that we end up creating new
> files deep within the mmap code, but I guess we won't be changing that
> in a hurry.

Hugh and I talked about merging it back into one file ala the x86 32/64
merge. I've put it on my todo list.

-- 
Mathematics is the supreme nostalgia of our time.

