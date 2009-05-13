Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZEMAqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZEMAqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439AbZEMAp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:45:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40829 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbZEMApz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:45:55 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH -mm] vmscan: protect a fraction of file backed mapped pages from reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
In-Reply-To: <alpine.DEB.1.10.0905121650090.14226@qirst.com>
References: <20090512120002.D616.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0905121650090.14226@qirst.com>
Message-Id: <20090513084306.5874.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 13 May 2009 09:45:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> All these expiration modifications do not take into account that a desktop
> may sit idle for hours while some other things run in the background (like
> backups at night or updatedb and other maintenance things). This still
> means that the desktop will be usuable in the morning.

Have you seen this phenomenom?
I always use linux desktop for development. but I haven't seen it.
perhaps I have no luck. I really want to know reproduce way.

Please let me know reproduce way.


> I have had some success with a patch that protects a pages in the file
> cache from being unmapped if the mapped pages are below a certain
> percentage of the file cache. Its another VM knob to define the percentage
> though.
> 
> 
> Subject: Do not evict mapped pages
> 
> It is quite annoying when important executable pages of the user interface
> are evicted from memory because backup or some other function runs and no one
> is clicking any buttons for awhile. Once you get back to the desktop and
> try to click a link one is in for a surprise. It can take quite a long time
> for the desktop to recover from the swap outs.
> 
> This patch ensures that mapped pages in the file cache are not evicted if there
> are a sufficient number of unmapped pages present. A similar technique is
> already in use under NUMA for zone reclaim. The same method can be used to
> protect mapped pages from reclaim.

note: (a bit offtopic)

some Nehalem machine has long node distance and enabled zone reclaim mode.
but it cause terrible result.

it only works on large numa.

> 
> The percentage of file backed pages protected is set via
> /proc/sys/vm/file_mapped_ratio. This defaults to 20%.

Why do you think typical mapped ratio is less than 20% on desktop machine?

Some desktop component (e.g. V4L, GEM, some game) use tons mapped page.
but in the other hand, another some desktop user only use browser.
So we can't assume typical mapped ratio on desktop, IMHO.

Plus, typical desktop user don't set any sysctl value.

key point is access-once vs access-many.
I don't think mapped ratio is good approximation value.




