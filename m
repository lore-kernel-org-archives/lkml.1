Return-Path: <linux-kernel-owner+w=401wt.eu-S1763142AbYDOJfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763142AbYDOJfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 05:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbYDOJfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 05:35:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:30833 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbYDOJfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=epb4lsyhtoM4KP47ZQC7ae8/eS5f24D3IEhdOIHN2YX5IBSuAgwdk6TXmwaFiRWrw/nQTH+Rpi1WYY9Pqk06esgpZ6xXNbBJWoUgXI6RTOcWYCFBXuTo89Wn5kTQhzfbmMsXNvSONGPIi3b4TG+LTsMR9rFjqADCy8LqIJ7sGKk=
Date: Tue, 15 Apr 2008 13:34:51 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 1/5] Clocklib: add generic framework for managing
	clocks.
Message-ID: <20080415093451.GA6377@doriath.ww600.siemens.net>
References: <20080413144138.GA31665@doriath.ww600.siemens.net> <20080413144312.GA1943@doriath.ww600.siemens.net> <20080414231330.b72cd746.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414231330.b72cd746.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 11:13:30PM -0700, Andrew Morton wrote:
> On Sun, 13 Apr 2008 18:43:12 +0400 Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> 
> > +#define FUNC_TO_CLK(func)	&(&(struct clk_function) func)->clk
> 
> scratched my head for a while, was unable to work out what this does.
> It is unused, so I think it can be zapped?

It take clk_function and returns pointer to the contained struct clk.
It's unused in the submitted code, but it's used in the yet-in-progress
drivers for Toshiba companion chips. I used it to be able to write
things like:

static struct clk *clks[] = {
        [TC6387XB_CLK_MMC] = FUNC_TO_CLK(MFD_CLK_FUNC(NULL, "MMCCLK",
				&tc6387xb_cells[TC6387XB_CELL_MMC])),
};

where MFD_CLK_FUNC instantiates some special sort of clk_function.

> 
> All the inlined functions in clklib.h are waaaaaaaaaaaay too big
> to be inlined.  Did I fail to notice that last time around?

OK.

> 
> Anyway, this patchset is basically an arm-only thing, so I'll need
> guidance, please...

They were posted to the LKML with CC to arch maintainers primary to get
their feedback. I have a hope that it can be used not only for various
arms, but for other arches. As you can see posting it here helped to make
the whole patchset better and less memory hungry.

As currently the patchset only contains the generic and ARM-related
things, I think it can and should go in via Russell, if he agrees.

Russell?

-- 
With best wishes
Dmitry

