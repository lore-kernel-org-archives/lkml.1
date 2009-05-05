Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZEEHkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZEEHkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 03:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZEEHjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 03:39:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:45047 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbZEEHjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 03:39:54 -0400
Subject: Re: [RFC][PATCH] vmscan: don't export nr_saved_scan in
 /proc/zoneinfo
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, torvalds@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com,
       riel@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       npiggin@suse.de, cl@linux-foundation.org
In-Reply-To: <20090504144915.8d0716d7.akpm@linux-foundation.org>
References: <200904302208.n3UM8t9R016687@imap1.linux-foundation.org>
	 <20090501012212.GA5848@localhost>
	 <20090430194907.82b31565.akpm@linux-foundation.org>
	 <20090502023125.GA29674@localhost> <20090502024719.GA29730@localhost>
	 <20090504144915.8d0716d7.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 05 May 2009 09:38:10 +0200
Message-Id: <1241509090.11059.31.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-04 at 14:49 -0700, Andrew Morton wrote:
> On Sat, 2 May 2009 10:47:19 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > The lru->nr_saved_scan's are not meaningful counters for even kernel
> > developers.  They typically are smaller than 32 and are always 0 for
> > large lists. So remove them from /proc/zoneinfo.
> > 
> > Hopefully this interface change won't break too many scripts.
> > /proc/zoneinfo is too unstructured to be script friendly, and I wonder
> > the affected scripts - if there are any - are still bleeding since the
> > not long ago commit "vmscan: split LRU lists into anon & file sets",
> > which also touched the "scanned" line :)
> > 
> > If we are to re-export accumulated vmscan counts in the future, they
> > can go to new lines in /proc/zoneinfo instead of the current form, or
> > to /sys/devices/system/node/node0/meminfo?
> > 
> 
> /proc/zoneinfo is unsalvageable :( Shifting future work over to
> /sys/devices/system/node/nodeN/meminfo and deprecating /proc/zoneinfo
> sounds good to me.

If only one could find things put in sysfs :-)
