Return-Path: <linux-kernel-owner+w=401wt.eu-S933233AbXBWWKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbXBWWKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 17:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933232AbXBWWKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 17:10:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:39153 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933233AbXBWWKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 17:10:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dp5qxngYJOM6nzJNS09RpHVyC+hIwT+uj+oI+4FFi4Ki4bo1Xrlb7v6LMfa+jCiRtEji/cmhU0FDe4iPVXNRfmmmsh1YSvmVP8d4YXweTIAlnQaMT6Z4OWbVfJrBgL436zyP2CTPHFs9t6tMFNVqir4y8R+1BM7fONQA8yNXrPY=
Message-ID: <1f1b08da0702231410x24728480n463d08540c1c665f@mail.gmail.com>
Date: Fri, 23 Feb 2007 14:10:07 -0800
From: "john stultz-lkml" <johnstul.lkml@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: radeon breaks with clocksource_jiffies
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070223.140328.74752162.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070223.134505.74749340.davem@davemloft.net>
	 <20070223.140328.74752162.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/23/07, David Miller <davem@davemloft.net> wrote:
> > While probeing PLL information via radeon_get_pllinfo(), it does a
> > "gettimeofday(); do_something(); gettimeofday();" type sequence
> > explicitly with interrupts disabled, so ends up with a zero
> > measurement which then results in a bunch of divisions by zero.
> >
> > We should decide whether gettimeofday() can be expected to advance with
> > interrupts disabled, or that clocksource_jiffies is simply invalid because
> > of this behavior.
>
> Actually, with clocksource based gettimeofday(), radeon built-in cannot
> work at all.
>
> The reason is that the clocksource code will not jump over to a
> clock source other than clocksource_jiffies until the late initcalls
> are run, because of this code:

Check out the patch I sent out yesterday. It should resolve this problem.

thanks
-john
