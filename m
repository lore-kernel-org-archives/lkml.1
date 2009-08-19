Return-Path: <linux-kernel-owner+w=401wt.eu-S1751054AbZHSGvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054AbZHSGvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 02:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750775AbZHSGvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 02:51:04 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:45462 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbZHSGvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 02:51:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=KCMXH5vV3ypA/TvwYzn6yjS472XS7mEE+Z6T7sIq7t7FrBqhdic7Gyb4nnumLBN3Ne
         j9vlJT3DxATaN/hJvYimqrlPFv27egWPomEiHYTTm+eU2A7W2MhrNbXX3XoB48K0pZLt
         N7JnTTys3Gk7w2rN5NewV/hp1d8SjRosjrdqc=
Date: Wed, 19 Aug 2009 15:49:58 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: =?UTF-8?B?7Jqw7Lap6riw?= <chungki.woo@gmail.com>,
       Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>, ngupta@vflare.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com, riel@redhat.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: abnormal OOM killer message
Message-Id: <20090819154958.18a34aa5.minchan.kim@barrios-desktop>
In-Reply-To: <18eba5a10908182324x45261d06y83e0f042e9ee6b20@mail.gmail.com>
References: <18eba5a10908181841t145e4db1wc2daf90f7337aa6e@mail.gmail.com>
	<20090819114408.ab9c8a78.minchan.kim@barrios-desktop>
	<4A8B7508.4040001@vflare.org>
	<20090819135105.e6b69a8d.minchan.kim@barrios-desktop>
	<18eba5a10908182324x45261d06y83e0f042e9ee6b20@mail.gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 15:24:54 +0900
우충기 <chungki.woo@gmail.com> wrote:

> Thank you very much for replys.
> 
> But I think it seems not to relate with stale data problem in compcache.
> My question was why last chance to allocate memory was failed.
> When OOM killer is executed, memory state is not a condition to
> execute OOM killer.
> Specially, there are so many pages of order 0. And allocating order is zero.
> I think that last allocating memory should have succeeded.
> That's my worry.

Yes. I agree with you.
Mel. Could you give some comment in this situation ?
Is it possible that order 0 allocation is failed 
even there are many pages in buddy ?

> 
> -----------------------------------------------------------------------------------------------------------------------------------------------
>       page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, order,
> <== this is last chance
>                            zonelist, ALLOC_WMARK_HIGH|ALLOC_CPUSET);
> <== uses ALLOC_WMARK_HIGH
>       if (page)
>       goto got_pg;
> 
>       out_of_memory(zonelist, gfp_mask, order);
>       goto restart;
> -----------------------------------------------------------------------------------------------------------------------------------------------
> 
> > Let me have a question.
> > Now the system has 79M as total swap.
> > It's bigger than system memory size.
> > Is it possible in compcache?
> > Can we believe the number?
> 
> Yeah, It's possible. 79Mbyte is data size can be swap.
> It's not compressed data size. It's just original data size.

You means your pages with 79M are swap out in compcache's reserved
memory?

> 
> Thanks,
> Minchan, Nitin


-- 
Kind regards,
Minchan Kim
