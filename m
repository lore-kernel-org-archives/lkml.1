Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbYEEEm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbYEEEm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 00:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYEEEmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 00:42:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:44278 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbYEEEms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 00:42:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XQ+sZAYHBSGQftuqVGfug2Ge64cRFC8j7KJ9FOJLaz1vXDVbb5MrNipnVR3+8O9VXkDZRHYRUwQbm1oTwC+uiCg+KmEqTyMEuxjzRuIwEsNLrFhlFUarhRxkiuiIroLePRgvDaepBtR8AbHOmAJMiCy3EACNVd/defeRFg25qtI=
Message-ID: <44c63dc40805042142k2e5bc366mffa9e0a22fbe94c9@mail.gmail.com>
Date: Mon, 5 May 2008 13:42:47 +0900
From: "minchan Kim" <barrioskmc@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 3/5] change function prototype of shrink_zone()
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080504215718.8F5B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080504215718.8F5B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  -static unsigned long shrink_zone(int priority, struct zone *zone,
>  -                               struct scan_control *sc)
>  +static int shrink_zone(int priority, struct zone *zone,
>  +                      struct scan_control *sc)
>   {
>         unsigned long nr_active;
>         unsigned long nr_inactive;
>  @@ -1236,8 +1239,9 @@ static unsigned long shrink_zone(int pri
>                 }
>         }
>
>  +       sc->nr_reclaimed += nr_reclaimed;
>         throttle_vm_writeout(sc->gfp_mask);
>  -       return nr_reclaimed;
>  +       return 0;
>   }

I am not sure this is right.
I might be wrong if this patch is depended on another patch.

As I see, shrink_zone always return 0 in your patch.

If it is right, I think that return value is useless. It is better
that we change function return type to "void"
Also, we have to change functions that call shrink_zone properly. ex)
balance_pgdat, __zone_reclaim
That functions still use number of shrink_zone's reclaim page

-- 
Thanks,
barrios
