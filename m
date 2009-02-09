Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbZBIXDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbZBIXDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbZBIXC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:02:56 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:38752 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbZBIXCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:02:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KHBehQms1oLbF3E7J3t8knAvZh+ZjVBzVqFZfODm2DwP0hmNu5eZ1C8nABb5Xxnw4L
         5hjeprk4COa2ieS9UivkVTQiHNzDEu1aRdcIA0Qjj+154feH2FwmqEp/l6Sn5exkGO76
         J7AbXHVuBAmRLHyV1fRIX3jubuXF2pBsrcgk8=
MIME-Version: 1.0
In-Reply-To: <20090209194309.GA8491@cmpxchg.org>
References: <20090206122129.79CC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20090206044907.GA18467@cmpxchg.org>
	 <20090206135302.628E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20090206122417.GB1580@cmpxchg.org>
	 <28c262360902060535g22facdd0tf082ca0abaec3f80@mail.gmail.com>
	 <28c262360902060915u18b2fb54t5f2c1f44d03306e3@mail.gmail.com>
	 <20090209194309.GA8491@cmpxchg.org>
Date: Tue, 10 Feb 2009 08:02:53 +0900
Message-ID: <28c262360902091502w5555528bt8e61e6c288aeff76@mail.gmail.com>
Subject: Re: [patch] vmscan: rename sc.may_swap to may_unmap
From: MinChan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 4:43 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> sc.may_swap does not only influence reclaiming of anon pages but pages
> mapped into pagetables in general, which also includes mapped file
> pages.
>
> From shrink_page_list():
>
>                if (!sc->may_swap && page_mapped(page))
>                        goto keep_locked;
>
> For anon pages, this makes sense as they are always mapped and
> reclaiming them always requires swapping.
>
> But mapped file pages are skipped here as well and it has nothing to
> do with swapping.
>
> The real effect of the knob is whether mapped pages are unmapped and
> reclaimed or not.  Rename it to `may_unmap' to have its name match its
> actual meaning more precisely.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/vmscan.c |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> On Sat, Feb 07, 2009 at 02:15:21AM +0900, MinChan Kim wrote:
>> Sorry for misunderstood your point.
>> It would be better to remain more detaily for git log ?
>>
>> 'may_swap' applies not only to anon pages but to mapped file pages as
>> well. 'may_swap' term is sometime used for 'swap', sometime used for
>> 'sync|discard'.
>> In case of anon pages, 'may_swap' determines whether pages were swapout or not.
>> but In case of mapped file pages, it determines whether pages are
>> synced or discarded. so, 'may_swap' is rather awkward. Rename it to
>> 'may_unmap' which is the actual meaning.
>>
>> If you find wrong word and sentence, Please, fix it. :)
>
> Is the above description okay for you?
>

It looks good to me. :)

Reviewed-by: MinChan Kim <minchan.kim@gmail.com>

-- 
Kinds regards,
MinChan Kim
