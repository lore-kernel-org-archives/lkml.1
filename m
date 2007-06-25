Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbXFYVBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbXFYVBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbXFYVA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:00:58 -0400
Received: from fw1-az.mvista.com ([65.200.49.156]:4447 "EHLO
	zipcode.az.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751426AbXFYVA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:00:57 -0400
Date: Mon, 25 Jun 2007 13:58:47 -0700
From: "Mark A. Greer" <mgreer@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Mark A. Greer" <mgreer@mvista.com>, linux-kernel@vger.kernel.org,
       jaylubo@motorola.com
Subject: Re: [PATCH] serial: Clear proper MPSC interrupt cause bits
Message-ID: <20070625205847.GA11031@mag.az.mvista.com>
References: <20070622023208.GA20651@mag.az.mvista.com> <20070623095144.0ec7e8c6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070623095144.0ec7e8c6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 09:51:44AM -0700, Andrew Morton wrote:
> > On Thu, 21 Jun 2007 19:32:08 -0700 "Mark A. Greer" <mgreer@mvista.com> wrote:
> > From: Jay Lubomirski <jaylubo@motorola.com>
> > 
> > Don't clobber the interrupt cause bits for both MPSC controllers when
> > clearing the interrupt for one of them.  Just clear the one that is
> > supposed to be cleared.
> > 
> > Signed-off-by: Jay Lubomirski <jaylubo@motorola.com>
> > Acked-by: Mark A. Greer <mgreer@mvista.com>
> > ---
> >  drivers/serial/mpsc.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/serial/mpsc.c b/drivers/serial/mpsc.c
> > index d09f209..00924fe 100644
> > --- a/drivers/serial/mpsc.c
> > +++ b/drivers/serial/mpsc.c
> > @@ -503,7 +503,8 @@ mpsc_sdma_intr_ack(struct mpsc_port_info *pi)
> >  
> >  	if (pi->mirror_regs)
> >  		pi->shared_regs->SDMA_INTR_CAUSE_m = 0;
> > -	writel(0, pi->shared_regs->sdma_intr_base + SDMA_INTR_CAUSE);
> > +	writeb(0x00, pi->shared_regs->sdma_intr_base + SDMA_INTR_CAUSE +
> > +	       pi->port.line);
> >  	return;
> >  }
> 
> In my naive little mpscless bubbleworld, I am believing that this is a
> pretty important fix, and that people in an mpscful world might want it in
> 2.6.22.  And even in 2.6.21.x.

Yes, that's probably true although the timing has to be just right for
it to occurs so its not that frequent.
I don't know what I have to do to get it into 2.6.22 at this late moment
(or 2.6.21.x for that matter).

> But alas, that's just a guess, which was forced upon me by the lack of
> suitable information in your changelog.

My aplogies.

> So please, tell us what are the real-world consequences of your patch (or
> the lack of it), thanks.

I'll resubmit the patch with a better description momentarily.
Sorry for the hassle.

Mark
