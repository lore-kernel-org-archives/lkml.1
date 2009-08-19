Return-Path: <linux-kernel-owner+w=401wt.eu-S1751258AbZHSGYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbZHSGYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 02:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbZHSGYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 02:24:54 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:43404 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZHSGYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 02:24:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a1HEws3ZKsTtLsOPvhuROrMwTzhsAv+88cD2YqI9XFFixk0+wVpResEU8IS7gX8HVV
         H9e1Deg1kPypW6bMF8GFzMgyBNJvuyQfEY9OEqaz5W9GxGhkMa8rz+S/yeCF+LCAg8LN
         b7LVgrrIfcfpCcqYeehbDVWzLfM/6i5k7e+hc=
MIME-Version: 1.0
In-Reply-To: <20090819135105.e6b69a8d.minchan.kim@barrios-desktop>
References: <18eba5a10908181841t145e4db1wc2daf90f7337aa6e@mail.gmail.com>
	 <20090819114408.ab9c8a78.minchan.kim@barrios-desktop>
	 <4A8B7508.4040001@vflare.org>
	 <20090819135105.e6b69a8d.minchan.kim@barrios-desktop>
Date: Wed, 19 Aug 2009 15:24:54 +0900
Message-ID: <18eba5a10908182324x45261d06y83e0f042e9ee6b20@mail.gmail.com>
Subject: Re: abnormal OOM killer message
From: =?UTF-8?B?7Jqw7Lap6riw?= <chungki.woo@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: ngupta@vflare.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, riel@redhat.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much for replys.

But I think it seems not to relate with stale data problem in compcache.
My question was why last chance to allocate memory was failed.
When OOM killer is executed, memory state is not a condition to
execute OOM killer.
Specially, there are so many pages of order 0. And allocating order is zero.
I think that last allocating memory should have succeeded.
That's my worry.

-----------------------------------------------------------------------------------------------------------------------------------------------
      page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, order,
<== this is last chance
                           zonelist, ALLOC_WMARK_HIGH|ALLOC_CPUSET);
<== uses ALLOC_WMARK_HIGH
      if (page)
      goto got_pg;

      out_of_memory(zonelist, gfp_mask, order);
      goto restart;
-----------------------------------------------------------------------------------------------------------------------------------------------

> Let me have a question.
> Now the system has 79M as total swap.
> It's bigger than system memory size.
> Is it possible in compcache?
> Can we believe the number?

Yeah, It's possible. 79Mbyte is data size can be swap.
It's not compressed data size. It's just original data size.

Thanks,
Minchan, Nitin
