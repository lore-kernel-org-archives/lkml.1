Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbZEAAvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbZEAAvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbZEAAus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:50:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757266AbZEAAuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:50:46 -0400
Date: Thu, 30 Apr 2009 17:45:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Elladan <elladan@eskimo.com>
Cc: riel@redhat.com, peterz@infradead.org, elladan@eskimo.com,
       linux-kernel@vger.kernel.org, tytso@mit.edu,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org
Subject: Re: [PATCH] vmscan: evict use-once pages first (v2)
Message-Id: <20090430174536.d0f438dd.akpm@linux-foundation.org>
In-Reply-To: <20090430072057.GA4663@eskimo.com>
References: <20090428044426.GA5035@eskimo.com>
	<20090428192907.556f3a34@bree.surriel.com>
	<1240987349.4512.18.camel@laptop>
	<20090429114708.66114c03@cuia.bos.redhat.com>
	<20090430072057.GA4663@eskimo.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 00:20:58 -0700
Elladan <elladan@eskimo.com> wrote:

> > Elladan, does this smaller patch still work as expected?
> 
> Rik, since the third patch doesn't work on 2.6.28 (without disabling a lot of
> code), I went ahead and tested this patch.
> 
> The system does seem relatively responsive with this patch for the most part,
> with occasional lag.  I don't see much evidence at least over the course of a
> few minutes that it pages out applications significantly.  It seems about
> equivalent to the first patch.
> 
> Given Andrew Morton's request that I track the Mapped: field in /proc/meminfo,
> I went ahead and did that with this patch built into a kernel.  Compared to the
> standard Ubuntu kernel, this patch keeps significantly more Mapped memory
> around, and it shrinks at a slower rate after the test runs for a while.
> Eventually, it seems to reach a steady state.
> 
> For example, with your patch, Mapped will often go for 30 seconds without
> changing significantly.  Without your patch, it continuously lost about
> 500-1000K every 5 seconds, and then jumped up again significantly when I
> touched Firefox or other applications.  I do see some of that behavior with
> your patch too, but it's much less significant.

Were you able to tell whether altering /proc/sys/vm/swappiness appropriately
regulated the rate at which the mapped page count decreased?

Thanks.
