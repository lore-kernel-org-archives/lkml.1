Return-Path: <linux-kernel-owner+w=401wt.eu-S965622AbXBTARl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965622AbXBTARl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965614AbXBTARF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:17:05 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:59744 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965642AbXBTAQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:16:08 -0500
Date: Mon, 19 Feb 2007 19:13:51 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: dirty balancing deadlock
Message-ID: <20070220001351.GJ6133@think.oraclecorp.com>
References: <E1HIqlm-0004iZ-00@dorka.pomaz.szeredi.hu> <20070218125307.4103c04a.akpm@linux-foundation.org> <E1HIurG-0005Bw-00@dorka.pomaz.szeredi.hu> <20070218145929.547c21c7.akpm@linux-foundation.org> <E1HIvMB-0005Fd-00@dorka.pomaz.szeredi.hu> <20070218155916.0d3c73a9.akpm@linux-foundation.org> <E1HJC3P-0006tz-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HJC3P-0006tz-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 06:11:55PM +0100, Miklos Szeredi wrote:
> How about this?
> 
> Solves the FUSE deadlock, but not the throttle_vm_writeout() one.
> I'll try to tackle that one as well.
> 
> If the per-bdi dirty counter goes below 16, balance_dirty_pages()
> returns.
> 
> Does the constant need to tunable?  If it's too large, then the global
> threshold is more easily exceeded.  If it's too small, then in a tight
> situation progress will be slower.

Ok, what is supposed to happen here is that filesystems are supposed to
be throttled from making more dirty pages when the system is over the
threshold.  Even if filesystem A doesn't have much to contribute, and
filesystem B is the cause of 99% of the dirty pages, the goal of the
threshold is to prevent more dirty data from happening, and filesystem A
should block.

But, with the producer consumer setup of fuse, I think this is a pretty
good compromise.  16 dirty/writeback pages shouldn't hurt the overall
limits too badly.

-chris

