Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbYEEFSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbYEEFSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 01:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYEEFSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 01:18:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:42314 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYEEFSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 01:18:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tN3vD8a8m6NPqvkJJoJxU0FZ5xbZyhMqHvN4vdGBdrXnmkBmyZ2K9RRfjQvgmXQ2QpWXh+D4TYjItjuBlgfMY0pqLcFHIIiZO/ib0D7VPqY+DCpmxAilASyHbYIxyHyC0qDpPKQq48TABiFwLrmtbUr2X/xmhoaGdhnKY2TBINY=
Message-ID: <a8e1da0805042218l6fbacfd9sa139b00c3077895b@mail.gmail.com>
Date: Mon, 5 May 2008 13:18:30 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH -mm] __ratelimit rewrite
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, "David Miller" <davem@davemloft.net>
In-Reply-To: <1209955974.13011.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080504070738.GA11832@darkstar.te-china.tietoenator.com>
	 <1209912447.16966.42.camel@localhost>
	 <a8e1da0805041837q4a5264c6l7bc23dce1d3282fd@mail.gmail.com>
	 <1209954305.13011.1.camel@localhost>
	 <a8e1da0805041958k30c03e20r6dd88f4135d6e5fe@mail.gmail.com>
	 <1209955974.13011.10.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2008 at 10:52 AM, Joe Perches <joe@perches.com> wrote:
>
> On Mon, 2008-05-05 at 10:58 +0800, Dave Young wrote:
>  > On Mon, May 5, 2008 at 10:25 AM, Joe Perches <joe@perches.com> wrote:
>  > > On Mon, 2008-05-05 at 09:37 +0800, Dave Young wrote:
>  > >  > >  I think your changes should then be done in
>  > >  > >  printk.h not creating a new ratelimit.h.
>  > >  > IMO ratelimit is not just for printk use now, so a standalone head
>  > >  > file is necessary.
>  > >  What other uses would ratelimit have?
>  > ratelimit is a general function,  another user of it is
>  > WARN_ON_RATELIMIT in this patch. It could have other usage in future.
>
>  You put WARN_ON_RATELIMIT in bug.h right?
>  WARN_ON in bug.h is a printk

Yes, warn is indeed printk, but it's not equal to printk.

>
>  printk.h should #include <asm/bug.h>
>  kernel.h should not include that file.
>
>  What non print related function could be served by ratelimit?

You can do some other handling except printk in ratelimit logic.

After searching the code, I guess DCCP-Sync ratelimit can use this feature.
David, am I right?

BTW, most of printk_ratelimit users should use their own
ratelimit_state, maybe I should do the replace work as a patch series.
