Return-Path: <linux-kernel-owner+w=401wt.eu-S965445AbZLQTdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965445AbZLQTdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965428AbZLQTds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:33:48 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:43523 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965425AbZLQTdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:33:47 -0500
Date: Thu, 17 Dec 2009 13:33:01 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, minchan.kim@gmail.com
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
In-Reply-To: <20091217084046.GA9804@basil.fritz.box>
Message-ID: <alpine.DEB.2.00.0912171331300.3638@router.home>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com> <20091216101107.GA15031@basil.fritz.box> <20091216191312.f4655dac.kamezawa.hiroyu@jp.fujitsu.com> <20091216102806.GC15031@basil.fritz.box> <20091216193109.778b881b.kamezawa.hiroyu@jp.fujitsu.com>
 <1261004224.21028.500.camel@laptop> <20091217084046.GA9804@basil.fritz.box>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009, Andi Kleen wrote:

> > There are a few interesting cases like stack extention and hugetlbfs,
> > but I think we could start by falling back to mmap_sem locked behaviour
> > if the speculative thing fails.
>
> You mean fall back to mmap_sem if anything sleeps? Maybe. Would need
> to check how many such points are really there.

You always need some reference on the mm_struct (mm_read_lock) if you are
going to sleep to ensure that mm_struct still exists after waking up (page
fault, page allocation). RCU and other spin locks are not helping there.

