Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbZHNV42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbZHNV42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbZHNV41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:56:27 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:17048 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbZHNV4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:56:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANZ5hUqrR7PE/2dsb2JhbAC5bogtkHsFhBk
X-IronPort-AV: E=Sophos;i="4.43,382,1246838400"; 
   d="scan'208";a="367561296"
From: Roland Dreier <rdreier@cisco.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Richard Sharpe <realrichardsharpe@gmail.com>, david@lang.hm,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Discard support
References: <200908122007.43522.ngupta@vflare.org>
	<20090813151312.GA13559@linux.intel.com>
	<20090813162621.GB1915@phenom2.trippelsdorf.de>
	<alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>
	<87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>
	<alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm>
	<87f94c370908131428u75dfe496x1b7d90b94833bf80@mail.gmail.com>
	<46b8a8850908131520s747e045cnd8db9493e072939d@mail.gmail.com>
	<87f94c370908131719l7d84c5d0x2157cfeeb2451bce@mail.gmail.com>
	<46b8a8850908131758s781b07f6v2729483c0e50ae7a@mail.gmail.com>
	<87f94c370908141433h111f819j550467bf31c60776@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 14 Aug 2009 14:56:26 -0700
In-Reply-To: <87f94c370908141433h111f819j550467bf31c60776@mail.gmail.com>
	(Greg Freemyer's message of "Fri, 14 Aug 2009 17:33:49 -0400")
Message-ID: <adafxbu3vqt.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Aug 2009 21:56:26.0655 (UTC) FILETIME=[125012F0:01CA1D2A]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > It seems to me that unmap is not all that different, why do we need to
 > do it even close in time proximity to the deletes?  With a bitmap, we
 > have total timing control of when the unmaps are forwarded down to the
 > device.  I like that timing control much better than a cache and
 > coalesce approach.

The trouble I see with a bitmap is the amount of memory it consumes.  It
seems that discards must be tracked on no bigger than 4KB sectors (and
possibly even 512 byte sectors).  But even with 4KB, then, say, a 32 TB
volume (just 16 * 2TB disks, or even lower end with thin provisioning)
requires 1 GB of bitmap memory.  Which is a lot just to store, let alone
walk over etc.

 - R.
