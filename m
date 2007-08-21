Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbXHUVNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbXHUVNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbXHUVNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:13:41 -0400
Received: from canuck.infradead.org ([209.217.80.40]:36471 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbXHUVNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:13:41 -0400
Subject: Re: [RFC 0/7] Postphone reclaim laundry to write at high water
	marks
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708211347480.3082@schroedinger.engr.sgi.com>
References: <20070820215040.937296148@sgi.com>
	 <1187692586.6114.211.camel@twins>
	 <Pine.LNX.4.64.0708211347480.3082@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Tue, 21 Aug 2007 23:13:32 +0200
Message-Id: <1187730812.5463.12.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 13:48 -0700, Christoph Lameter wrote:
> On Tue, 21 Aug 2007, Peter Zijlstra wrote:
> 
> > This almost insta-OOMs with anonymous workloads.
> 
> What does the workload do? So writeout needs to begin earlier. There are 
> likely issues with throttling.

The workload is a single program mapping 256M of anonymous memory and
cycling through it with writes ran on a 128M setup.

It quickly ends up with all of memory in the laundry list and then
recursing into __alloc_pages which will fail to make progress and OOMs.

But aside from the numerous issues with the patch set as presented, I'm
not seeing the seeing the big picture, why are you doing this.

Anonymous pages are a there to stay, and we cannot tell people how to
use them. So we need some free or freeable pages in order to avoid the
vm deadlock that arises from all memory dirty.

Currently we keep them free, this has the advantage that the buddy
allocator can at least try to coalese them.

'Optimizing' this by switching to freeable pages has mainly
disadvantages IMHO, finding them scrambles LRU order and complexifies
relcaim and all that for a relatively small gain in space for clean
pagecache pages.

Please, stop writing patches and write down a solid proposal of how you
envision the VM working in the various scenarios and why its better than
the current approach.

