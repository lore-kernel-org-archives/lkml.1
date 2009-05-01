Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbZEABBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbZEABBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 21:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZEABBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 21:01:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35131 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbZEABA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 21:00:59 -0400
Date: Thu, 30 Apr 2009 20:59:36 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Elladan <elladan@eskimo.com>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, tytso@mit.edu,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org
Subject: Re: [PATCH] vmscan: evict use-once pages first (v2)
Message-ID: <20090430205936.0f8b29fc@riellaptop.surriel.com>
In-Reply-To: <20090430174536.d0f438dd.akpm@linux-foundation.org>
References: <20090428044426.GA5035@eskimo.com>
	<20090428192907.556f3a34@bree.surriel.com>
	<1240987349.4512.18.camel@laptop>
	<20090429114708.66114c03@cuia.bos.redhat.com>
	<20090430072057.GA4663@eskimo.com>
	<20090430174536.d0f438dd.akpm@linux-foundation.org>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 17:45:36 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> Were you able to tell whether altering /proc/sys/vm/swappiness
> appropriately regulated the rate at which the mapped page count
> decreased?

That should not make a difference at all for mapped file
pages, after the change was merged that makes the VM ignores
the referenced bit of mapped active file pages.

Ever since the split LRU code was merged, all that the
swappiness controls is the aggressiveness of file vs
anonymous LRU scanning.

Currently the kernel has no effective code to protect the 
page cache working set from streaming IO.  Elladan's bug
report shows that we do need some kind of protection...

-- 
All rights reversed.
