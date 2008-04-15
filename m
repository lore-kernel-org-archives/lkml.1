Return-Path: <linux-kernel-owner+w=401wt.eu-S1763836AbYDOJso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763836AbYDOJso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 05:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757762AbYDOJsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 05:48:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755237AbYDOJsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:48:36 -0400
Date: Tue, 15 Apr 2008 02:47:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 1/5] Clocklib: add generic framework for managing
 clocks.
Message-Id: <20080415024743.51aeac8c.akpm@linux-foundation.org>
In-Reply-To: <20080415093451.GA6377@doriath.ww600.siemens.net>
References: <20080413144138.GA31665@doriath.ww600.siemens.net>
	<20080413144312.GA1943@doriath.ww600.siemens.net>
	<20080414231330.b72cd746.akpm@linux-foundation.org>
	<20080415093451.GA6377@doriath.ww600.siemens.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 13:34:51 +0400 Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> On Mon, Apr 14, 2008 at 11:13:30PM -0700, Andrew Morton wrote:
> > On Sun, 13 Apr 2008 18:43:12 +0400 Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> > 
> > > +#define FUNC_TO_CLK(func)	&(&(struct clk_function) func)->clk
> > 
> > scratched my head for a while, was unable to work out what this does.
> > It is unused, so I think it can be zapped?
> 
> It take clk_function and returns pointer to the contained struct clk.

Then why does it cast a clk_function to a clk_function?

The innermost `&' hurts my brain.

> I used it to be able to write things like:
> 
> static struct clk *clks[] = {
> 	        [TC6387XB_CLK_MMC] = FUNC_TO_CLK(MFD_CLK_FUNC(NULL, "MMCCLK",
> 					&tc6387xb_cells[TC6387XB_CELL_MMC])),
> };
> 

erm, if you say so.  Is this as simple and clear as we can possibly make it?
