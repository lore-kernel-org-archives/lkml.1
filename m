Return-Path: <linux-kernel-owner+w=401wt.eu-S1761966AbZLPKLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761966AbZLPKLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761940AbZLPKLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:11:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58521 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761948AbZLPKLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:11:13 -0500
Date: Wed, 16 Dec 2009 11:11:07 +0100
From: Andi Kleen <andi@firstfloor.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, andi@firstfloor.org,
       minchan.kim@gmail.com
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
Message-ID: <20091216101107.GA15031@basil.fritz.box>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 12:00:11PM +0900, KAMEZAWA Hiroyuki wrote:
> This is from Christoph Lameter's mm_accessor patch posted 5/Nov.
> 
> Replacing all access to mm->mmap_sem with mm-accessor functions as
>  mm_read_lock,
>  mm_write_lock,
>  etc...
> 
> This kind of function allows us to improve page fault performance etc..
> For example, skil down_read(mmap_sem) in some situation.
> (as: http://marc.info/?l=linux-mm&m=125809791306459&w=2)

The problem is that it also slows down the writers, and we have
some workloads where writing is the bottleneck.

I don't think this is the right trade off at this time.

Also the patches didn't fare too well in testing unfortunately.

I suspect we'll rather need multiple locks split per address
space range.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
