Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbXECIuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbXECIuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965539AbXECIuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:50:06 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4375 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932768AbXECIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:50:04 -0400
Message-ID: <4639A21A.6080806@shadowen.org>
Date: Thu, 03 May 2007 09:49:30 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Joel Schopp <jschopp@austin.ibm.com>
CC: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       clameter@engr.sgi.com, mingo@elte.hu, arjan@infradead.org,
       mbligh@mbligh.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org> <Pine.LNX.4.64.0703011642190.12485@woody.linux-foundation.org> <45E8594B.6020904@austin.ibm.com> <20070305032116.GA29678@wotan.suse.de> <45EC352A.7060802@austin.ibm.com>
In-Reply-To: <45EC352A.7060802@austin.ibm.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joel Schopp wrote:
>> But if you don't require a lot of higher order allocations anyway, then
>> guest fragmentation caused by ballooning doesn't seem like much problem.
> 
> If you only need to allocate 1 page size and smaller allocations then no
> it's not a problem.  As soon as you go above that it will be.  You don't
> need to go all the way up to MAX_ORDER size to see an impact, it's just
> increasingly more severe as you get away from 1 page and towards MAX_ORDER.

Yep, the allocator thinks of things less than order-4 as "easy to
obtain" in that it is willing to wait indefinatly for one to to appear,
above that they are not expected to appear.  With random placement the
chances of finding a page tend to 0 pretty quickly as order increases.
That was the motivation for the linear reclaim/lumpy reclaim patch
series which do make it significantly more possible to get higher
orders.  However very high orders such as we see with huge pages are
still almost impossible to obtain without placement controls in place.

-apw
