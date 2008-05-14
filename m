Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbYENWcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbYENWcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYENWcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:32:22 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48775 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753763AbYENWcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:32:21 -0400
Date: Wed, 14 May 2008 15:32:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <matthew@wil.cx>
cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <20080514220058.GG9921@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0805141521550.20277@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
 <482B2617.5010605@firstfloor.org> <Pine.LNX.4.64.0805141104260.15633@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0805141333550.18231@schroedinger.engr.sgi.com>
 <20080514205842.GC9921@parisc-linux.org> <Pine.LNX.4.64.0805141359420.18958@schroedinger.engr.sgi.com>
 <20080514212130.GD9921@parisc-linux.org> <Pine.LNX.4.64.0805141426440.19073@schroedinger.engr.sgi.com>
 <20080514214326.GF9921@parisc-linux.org> <Pine.LNX.4.64.0805141444220.19897@schroedinger.engr.sgi.com>
 <20080514220058.GG9921@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Matthew Wilcox wrote:

> Since there's no way we've found to date to get the TPC test to you,
> how about we settle for analysing _this_ testcase which did show a
> significant performance degradation for slub?
> 
> I don't think it's an unreasonable testcase either -- effectively it's
> allocating memory on all CPUs and then freeing it all on one.  If that's
> a worst-case scenario for slub, then slub isn't suitable for replacing
> slab yet.

Indeed that is a worst case scenario due to finer grained locking. The 
opposite side of that is that fast concurrent freeing of objects from two 
processors will have higher performance in slub since there is 
significantly less global lock contention and less work with expiring 
objects and moving them around (if you hit the queue limits then SLAB 
will do synchroonous merging of objects into slabs, its then no longer 
able to hide the object handling overhead in cache_reap().)

