Return-Path: <linux-kernel-owner+w=401wt.eu-S1762192AbXIKFwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762192AbXIKFwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 01:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760944AbXIKFwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 01:52:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34297 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760929AbXIKFwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 01:52:31 -0400
Date: Mon, 10 Sep 2007 22:52:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: sylvain.meyer@worldonline.fr, <linux-kernel@vger.kernel.org>,
       "Antonino A. Daplas" <adaplas@pol.net>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] Intel FB pixel clock calculation fix
Message-Id: <20070910225221.f0eaf22c.akpm@linux-foundation.org>
In-Reply-To: <m3ir6il3wl.fsf@maximus.localdomain>
References: <m3ir6il3wl.fsf@maximus.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 21:24:42 +0200 Krzysztof Halasa <khc@pm.waw.pl> wrote:

> Intel framebuffer mis-calculated pixel clocks.
> 
> Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
> 
> --- a/drivers/video/intelfb/intelfbhw.c
> +++ b/drivers/video/intelfb/intelfbhw.c
> @@ -924,10 +920,10 @@ calc_pll_params(int index, int clock, u32 *retm1, u32 *retm2, u32 *retn, u32 *re
>  			if (m > pll->max_m)
>  				m = pll->max_m - 1;
>  			for (testm = m - 1; testm <= m; testm++) {
> -				f_out = calc_vclock3(index, m, n, p);
> +				f_out = calc_vclock3(index, testm, n, p);
>  				if (splitm(index, testm, &m1, &m2)) {
> -					WRN_MSG("cannot split m = %d\n", m);
> -					n++;
> +					WRN_MSG("cannot split m = %d\n",
> +						testm);
>  					continue;
>  				}
>  				if (clock > f_out)

and... what are the consequences of this miscalculation?  I need to know
such things so that I can decide whether a change is needed in 2.6.23.  And
2.6.22.

Thanks.
