Return-Path: <linux-kernel-owner+w=401wt.eu-S1751006AbXDUSHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbXDUSHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 14:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbXDUSHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 14:07:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53477 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbXDUSHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 14:07:51 -0400
Message-ID: <462A52BF.7000801@redhat.com>
Date: Sat, 21 Apr 2007 14:06:55 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
References: <46247427.6000902@redhat.com> <20070420135715.f6e8e091.akpm@linux-foundation.org> <462932BE.4020005@redhat.com> <Pine.LNX.4.64.0704210818580.25689@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0704210818580.25689@blonde.wat.veritas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Fri, 20 Apr 2007, Rik van Riel wrote:
>> Andrew Morton wrote:
>>
>>>   I do go on about that.  But we're adding page flags at about one per
>>>   year, and when we run out we're screwed - we'll need to grow the
>>>   pageframe.
>> If you want, I can take a look at folding this into the
>> ->mapping pointer.  I can guarantee you it won't be
>> pretty, though :)
> 
> Please don't.  If we're going to stuff another pageflag into there,
> let it be PageSwapCache the natural partner of PageAnon, rather than
> whatever our latest pageflag happens to be. 

I looked at doing what Andrew wanted, and it did indeed not
look like the right thing to do.  The locking on page->mapping
is the kind of locking we want to avoid during zap_page_range
and in the pageout code.

I like your suggestion better.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
