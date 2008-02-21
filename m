Return-Path: <linux-kernel-owner+w=401wt.eu-S1764835AbYBUPbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764835AbYBUPbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 10:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbYBUPb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:31:26 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:4424 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbYBUPbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:31:25 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: pnp_bus_resume(): inconsequent NULL checking
Date: Thu, 21 Feb 2008 08:26:53 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Adrian Bunk <bunk@kernel.org>, ambx1@neo.rr.com,
       linux-kernel@vger.kernel.org
References: <20080219224908.GM31955@cs181133002.pp.htv.fi> <200802200959.21814.bjorn.helgaas@hp.com> <47BD1069.1060109@keyaccess.nl>
In-Reply-To: <47BD1069.1060109@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802210826.53731.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2008 10:47:21 pm Rene Herman wrote:
> On 20-02-08 17:59, Bjorn Helgaas wrote:
> > I agree with you that we can just delete the dev->protocol tests
> > completely. So I'd rather see something like this (built but untested):
> >
> >
> > PNP: remove dev->protocol NULL checks
> >
> > Every PNP device should have a valid protocol pointer.  If it doesn't,
> > something's wrong and we should oops so we can find and fix the problem.
> >
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>
> Ack from a functional standpoint: we are oopsing in pnp_start/stop_dev
> _anyway_ if the protocol pointer isn't set.
>
> Will you coach this upstream? A 2.6.25-rc1 change from me made the coverity
> checker pick up on it which might be considered enough of an excuse to call
> it a regression and submit this as a fix...

I'll push it upstream, but a coverity warning seems like a marginal
excuse for putting it in 2.6.25.  Is there any real reason it can't
wait until 2.6.26?

> > Index: work6/drivers/pnp/driver.c
> > ===================================================================
> > --- work6.orig/drivers/pnp/driver.c	2008-02-20 09:46:01.000000000 -0700
> > +++ work6/drivers/pnp/driver.c	2008-02-20 09:46:28.000000000 -0700
> > @@ -167,7 +167,7 @@
> >  			return error;
> >  	}
> >
> > -	if (pnp_dev->protocol && pnp_dev->protocol->suspend)
> > +	if (pnp_dev->protocol->suspend)
> >  		pnp_dev->protocol->suspend(pnp_dev, state);
> >  	return 0;
> >  }
> > @@ -181,7 +181,7 @@
> >  	if (!pnp_drv)
> >  		return 0;
> >
> > -	if (pnp_dev->protocol && pnp_dev->protocol->resume)
> > +	if (pnp_dev->protocol->resume)
> >  		pnp_dev->protocol->resume(pnp_dev);
> >
> >  	if (pnp_can_write(pnp_dev)) {
>
> Rene.


