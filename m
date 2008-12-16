Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbYLPNU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbYLPNU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 08:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYLPNUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 08:20:51 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:58175 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751762AbYLPNUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 08:20:51 -0500
Date: Tue, 16 Dec 2008 22:18:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: hjk@linutronix.de, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, magnus.damm@gmail.com
Subject: Re: [RESEND][PATCH] uio: Add of_platform_driver to uio_pdrv_genirq
Message-ID: <20081216131849.GA30249@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Wolfram Sang <w.sang@pengutronix.de>, hjk@linutronix.de,
	gregkh@suse.de, linux-kernel@vger.kernel.org,
	linuxppc-dev@ozlabs.org, magnus.damm@gmail.com
References: <1229007937-5501-1-git-send-email-w.sang@pengutronix.de> <20081216122524.GA29546@linux-sh.org> <20081216124156.GD3275@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216124156.GD3275@pengutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 01:41:56PM +0100, Wolfram Sang wrote:
> > In addition to the stuff pointed out by Greg, I don't see what you
> > actually gain by hacking the OF crap in to this driver. You would be
> > better off layering the OF driver on top of this, rather than trying to
> > make them live together in the same file.
> > 
> > See pata_platform/pata_of_platform for an example of how to do this a bit
> > more sanely.
> 
> See my reply just posted. I found two ways to go, and from reading
> discussions on the lists, finally decided for this way. May have been
> the wrong path, but nothing that could not be changed.
> 
I guess there are a couple of things to consider. If it fits in fairly
nicely and can be optimized out for the users that don't care, then
integration generally makes sense. In this case however you have a large
and insular block that is ifdef'ed in and selected by Kconfig, suggesting
that the only benefit is for your driver which wishes to tie in to parts
of uio_pdrv_genirq, with there being no benefits the other way. This sort
of situation suggests you are better off layering and simply exposing the
functionality you need from uio_pdrv_genirq. This was certainly the case
with pata_platform as well, and it worked out pretty well there compared
to hacking it in-place.
