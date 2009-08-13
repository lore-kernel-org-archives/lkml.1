Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbZHMPSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbZHMPSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZHMPSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:18:13 -0400
Received: from mail.lang.hm ([64.81.33.126]:37905 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbZHMPSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:18:12 -0400
Date: Thu, 13 Aug 2009 08:17:34 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Wilcox <willy@linux.intel.com>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Nitin Gupta <ngupta@vflare.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
 slot is freed)
In-Reply-To: <20090813151312.GA13559@linux.intel.com>
Message-ID: <alpine.DEB.2.00.0908130815450.30426@asgard.lang.hm>
References: <200908122007.43522.ngupta@vflare.org> <Pine.LNX.4.64.0908122312380.25501@sister.anvils> <20090813151312.GA13559@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009, Matthew Wilcox wrote:

> So TRIM isn't free, and there's a better way for the drive to find
> out that the contents of a block no longer matter -- write some new
> data to it.  So if we just swapped a page in, and we're going to swap
> something else back out again soon, just write it to the same location
> instead of to a fresh location.  You've saved a command, and you've
> saved the drive some work, plus you've allowed other users to continue
> accessing the drive in the meantime.

on the other hand, if you then end up swapping the page you read in out 
again and haven't dirtied it, you now have to actually write it as opposed 
to just throwing it away (knowing that you already have a copy of it 
stored on the swap device)

David Lang
