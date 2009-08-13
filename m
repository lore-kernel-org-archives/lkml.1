Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbZHMP0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbZHMP0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbZHMP0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:26:36 -0400
Received: from mga06.intel.com ([134.134.136.21]:52950 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750845AbZHMP0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:26:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,375,1246863600"; 
   d="scan'208";a="438696903"
Date: Thu, 13 Aug 2009 08:26:36 -0700
From: Matthew Wilcox <willy@linux.intel.com>
To: david@lang.hm
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Nitin Gupta <ngupta@vflare.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
	slot is freed)
Message-ID: <20090813152636.GB13559@linux.intel.com>
References: <200908122007.43522.ngupta@vflare.org> <Pine.LNX.4.64.0908122312380.25501@sister.anvils> <20090813151312.GA13559@linux.intel.com> <alpine.DEB.2.00.0908130815450.30426@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908130815450.30426@asgard.lang.hm>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 08:17:34AM -0700, david@lang.hm wrote:
> On Thu, 13 Aug 2009, Matthew Wilcox wrote:
>
>> So TRIM isn't free, and there's a better way for the drive to find
>> out that the contents of a block no longer matter -- write some new
>> data to it.  So if we just swapped a page in, and we're going to swap
>> something else back out again soon, just write it to the same location
>> instead of to a fresh location.  You've saved a command, and you've
>> saved the drive some work, plus you've allowed other users to continue
>> accessing the drive in the meantime.
>
> on the other hand, if you then end up swapping the page you read in out  
> again and haven't dirtied it, you now have to actually write it as 
> opposed to just throwing it away (knowing that you already have a copy of 
> it stored on the swap device)

This is true, but at the point where you call discard, you will also
have to write it again.  My point was about delaying calls to discard,
rather than moving the point, or changing the circumstances under which
one calls discard.
