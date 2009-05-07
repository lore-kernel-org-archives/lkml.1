Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbZEGF3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbZEGF3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 01:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbZEGF3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 01:29:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46343 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbZEGF3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 01:29:22 -0400
Date: Thu, 07 May 2009 14:29:15 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] Double check memmap is actually valid with a memmap has unexpected holes
Cc: Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, hartleys@visionengravers.com,
       mcrapet@gmail.com, linux@arm.linux.org.uk, fred99@carolina.rr.com,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Badari Pulavarty <pbadari@us.ibm.com>
In-Reply-To: <20090506155043.GA3084@cmpxchg.org>
References: <20090506143059.GB20709@csn.ul.ie> <20090506155043.GA3084@cmpxchg.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20090507142143.0619.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.05 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

> > > +		unsigned long pfn;
> > >  
> > > -		pgdat_resize_lock(pgdat, &flags);
> > 
> > How sure are you about removing the acquisition of this lock?  If anything,
> > it appears that pagetypeinfo_showblockcount_print() should be taking this lock.
> 
> I'm completely unsure about it.
> 
> <adds memory hotplug guys to CC>

zone->zone_start_pfn and zone->spanned_pages may be changed by memory hotplug.
The lock must be acquired before getting their values as Mel-san said.

Thanks.

-- 
Yasunori Goto 


