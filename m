Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYCaQTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYCaQTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 12:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYCaQTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 12:19:00 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:48789 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168AbYCaQS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 12:18:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NTNZGHDftgejP1/Y+N2HlhoXke7XXFj32MDNEjeKYErwvyPhaS5+KLr/Fml8C2xoc9epynCphgkiKQYpOqkhCzynGCvaXQH+kbZMhZ68tapylcVbV+zGxFetINyFCEqUeXtTyapkdKRNUga9Pr3uF4d8OHhHzOMTWw/al+o8Kbk=
Message-ID: <bc64b4640803310918u71bb2e2axeef67b13ad507ceb@mail.gmail.com>
Date: Mon, 31 Mar 2008 19:18:54 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH 1/6] Clocklib: add generic framework for managing clocks.
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "pHilipp Zabel" <philipp.zabel@gmail.com>, tony@atomide.com,
       paul@pwsan.com
In-Reply-To: <20080331145515.GA10969@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080331083947.GA11282@doriath.ww600.siemens.net>
	 <20080331084420.GA11617@doriath.ww600.siemens.net>
	 <20080331145515.GA10969@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/3/31, Pavel Machek <pavel@ucw.cz>:
>
>  > +int __must_check clk_register(struct clk *clk);
>  > +void clk_unregister(struct clk *clk);
>  > +static void __maybe_unused clks_unregister(struct clk **clks, size_t num)
>  > +{
>  > +     int i;
>  > +     for (i = num - 1; i >= 0;  i++) {
>  > +             clk_unregister(clks[i]);
>  > +     }
>  > +}
>  > +
>  > +static int __must_check __maybe_unused clks_register(struct clk **clks, size_t num)
>  > +{
>  > +     int i;
>  > +     int ret;
>  > +     for (i = 0; i < num; i++) {
>  > +             ret = clk_register(clks[i]);
>  > +             if (ret != 0)
>  > +                     goto cleanup;
>  > +     }
>  > +
>  > +     return 0;
>  > +
>  > +cleanup:
>  > +     clks_unregister(clks, i);
>  > +
>  > +     for (i -- ; i >= 0; i--) {
>
>
> "for (i--;"

ack

>
> > +             clk_unregister(clks[i]);
>  > +     }
>  > +
>  > +     return ret;
>
>
> Hmm, clk_unregister is _very_ similar to clks_unregister....

oops :)

-- 
With best wishes
Dmitry
