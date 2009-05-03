Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbZECQbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbZECQbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 12:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbZECQbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 12:31:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35387 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbZECQbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 12:31:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 0/4] PM: Drop shrink_all_memory (rev. 2) (was: Re: [PATCH 3/3] PM/Hibernate: Use memory allocations to free memory)
Date: Sun, 3 May 2009 18:30:48 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905030220.57933.rjw@sisk.pl> <20090503130818.GC9661@localhost>
In-Reply-To: <20090503130818.GC9661@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905031830.49690.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 May 2009, Wu Fengguang wrote:
> 
> Hi Rafael,

Hi,

> I happened to be doing some benchmarks on the older shrink_all_memory(),
> Hopefully it can be a useful reference point for the new design.
> 
> The current swsusp_shrink_memory()/shrink_all_memory() are terribly
> inefficient: it takes 7-9s to free up 1.4G memory:

One reason may be that it takes too many steps to do it,

> [  131.899389] PM: Freed 1413380 kbytes in 7.03 seconds (201.04 MB/s)
> [  732.757916] PM: Freed 1490116 kbytes in 9.37 seconds (159.03 MB/s)

because the new way doesn't seem to do any better.

> Below are the logs I collected by injecting printks. There are
> basically two major problems:
> - swsusp_shrink_memory() scans the whole 2G memory again and again;
> - shrink_all_memory() is slow. It won't reclaim pages at all with
>   small priority values, because it's batching size is 10000 pages.

I know that swsusp_shrink_memory() has problems, that's why I'd like to get rid
of it.

> I wonder if it's possible to free up the memory within 1s at all.

I'm not sure.

Apparently, the counting of saveable pages takes substantial time (0.5 s each
iteration on my 64-bit test box), so we can improve that by limiting the number
of iterations.

Well, perhaps we can do it all in one shot after all, I'll think how to do that.

Thanks,
Rafael
