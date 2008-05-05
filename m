Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbYEEIbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbYEEIbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYEEIb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:31:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:49875 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbYEEIb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:31:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XyKdn0GsXXzSDFmySB8uc40ZVIK4ddRennW6W9e9q9gMk2A8D8iyaOAZTWsW3zBGoVuLepPw0/mkWK+1EAeiJFBmo1yGMG/do3b7KISIdFgTl1hNmxxNZSWkLgKXBTAkbWSp61PFSIls8Bs742aRHHTwiHB0aO+WhQ7TBR13Dx4=
Message-ID: <2f11576a0805050131k6df2c0d6r93edb4893ad655b9@mail.gmail.com>
Date: Mon, 5 May 2008 17:31:27 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "minchan Kim" <barrioskmc@gmail.com>
Subject: Re: [-mm][PATCH 3/5] change function prototype of shrink_zone()
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <44c63dc40805042142k2e5bc366mffa9e0a22fbe94c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080504215718.8F5B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <44c63dc40805042142k2e5bc366mffa9e0a22fbe94c9@mail.gmail.com>
X-Google-Sender-Auth: a8b0d074ab2b7e5f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>  >  +       sc->nr_reclaimed += nr_reclaimed;
>  >         throttle_vm_writeout(sc->gfp_mask);
>  >  -       return nr_reclaimed;
>  >  +       return 0;
>  >   }
>
>  I am not sure this is right.
>  I might be wrong if this patch is depended on another patch.
>
>  As I see, shrink_zone always return 0 in your patch.

Yeah, this patch is just preparetion change of [4/5].
I use EAGAIN at [4/5].


>  If it is right, I think that return value is useless. It is better
>  that we change function return type to "void"
>  Also, we have to change functions that call shrink_zone properly. ex)
>  balance_pgdat, __zone_reclaim
>  That functions still use number of shrink_zone's reclaim page

this patch is not intent by solo usage.
just intent to bisect friendly.
thus, We need implement that following patch use freature only.

Thanks!
