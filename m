Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbZELRIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbZELRIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZELRIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:08:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40294 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbZELRIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:08:30 -0400
Message-ID: <4A09AC91.4060506@redhat.com>
Date: Tue, 12 May 2009 13:06:25 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH -mm] vmscan: protect a fraction of file backed mapped
 pages from reclaim
References: <20090508125859.210a2a25.akpm@linux-foundation.org> <20090512025246.GC7518@localhost> <20090512120002.D616.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0905121650090.14226@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0905121650090.14226@qirst.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> All these expiration modifications do not take into account that a desktop
> may sit idle for hours while some other things run in the background (like
> backups at night or updatedb and other maintenance things). This still
> means that the desktop will be usuable in the morning.

New file pages start on the inactive list and will get reclaimed
after one access. Only file pages that get accessed multiple times
get promoted to the active file LRU.

The patch that only allows active file pages to be deactivated
if the active file LRU is larger than the inactive file LRU should
protect the working set from being evicted due to streaming IO.

Even if the working set is currently idle.

> I have had some success with a patch that protects a pages in the file
> cache from being unmapped if the mapped pages are below a certain
> percentage of the file cache. Its another VM knob to define the percentage
> though.

That is another way of protecting mapped file pages, but it does
not have the side effect of protecting the page cache working set
on eg. file servers or mysql or postgresql installs with default
tunables (which rely heavily on the page cache to cache the right
things).

-- 
All rights reversed.
