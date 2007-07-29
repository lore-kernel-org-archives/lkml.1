Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbXG2EIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbXG2EIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 00:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbXG2EIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 00:08:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbXG2EIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 00:08:14 -0400
Message-ID: <46AC1297.9030009@redhat.com>
Date: Sun, 29 Jul 2007 00:07:51 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: How can we make page replacement smarter (was: swap-prefetch)
References: <200707272243.02336.a1426z@gawab.com> <200707280717.41250.a1426z@gawab.com> <46AAEFC4.8000006@redhat.com> <200707281411.57823.a1426z@gawab.com>
In-Reply-To: <200707281411.57823.a1426z@gawab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Chris Snook wrote:

>> At best, reads can be read-ahead and cached, which is why
>> sequential swap-in sucks less.  On-demand reads are as expensive as I/O
>> can get.
> 
> Which means that it should be at least as fast as swap-out, even faster 
> because write to disk is usually slower than read on modern disks.  But 
> linux currently shows a distinct 2x slowdown for sequential swap-in wrt 
> swap-out. 

That's because writes are faster than reads in moderate
quantities.

The disk caches writes, allowing the OS to write a whole
bunch of data into the disk cache and the disk can optimize
the IO a bit internally.

The same optimization is not possible for reads.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
