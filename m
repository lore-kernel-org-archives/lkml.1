Return-Path: <linux-kernel-owner+w=401wt.eu-S1761301AbZENRC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301AbZENRC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZENRCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:02:15 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:35760 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbZENRCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:02:13 -0400
Date: Fri, 15 May 2009 02:02:11 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, hartleys@visionengravers.com,
       mcrapet@gmail.com, linux@arm.linux.org.uk, fred99@carolina.rr.com,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] Double check memmap is actually valid with a memmap has unexpected holes
Message-ID: <20090514170211.GA5129@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, hartleys@visionengravers.com,
	mcrapet@gmail.com, linux@arm.linux.org.uk, fred99@carolina.rr.com,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Badari Pulavarty <pbadari@us.ibm.com>,
	Yasunori Goto <y-goto@jp.fujitsu.com>
References: <20090505082944.GA25904@csn.ul.ie> <20090505110653.GA16649@cmpxchg.org> <20090506143059.GB20709@csn.ul.ie> <20090506155043.GA3084@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506155043.GA3084@cmpxchg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 05:50:43PM +0200, Johannes Weiner wrote:
> On Wed, May 06, 2009 at 03:31:00PM +0100, Mel Gorman wrote:
> > As it turns out, ARM has its own show_mem(). I don't see how, but ARM
> > must not be using lib/show_mem.c even though it compiles it.
> 
> It's some linker magic for lib/.  It compiles both but treats the
> library version as weak symbol (or something).
> 
This is true for lib-y handling in general, which lib/show_mem.o falls
under. Much of lib/ is obj-y though due to the fact that EXPORT_SYMBOL's
from lib-y are ineffective (people seem to get bitten by this at least
once a week), as a result, many things that start out as lib-y are
gradually moved over to obj-y, meaning that __weak annotations in obj-y
objects start to take precedent over lib-y magic anyways.. :-)
