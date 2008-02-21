Return-Path: <linux-kernel-owner+w=401wt.eu-S1762035AbYBUQKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762035AbYBUQKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760617AbYBUQJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:09:51 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54267 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428AbYBUQJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:09:50 -0500
Date: Thu, 21 Feb 2008 18:09:07 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>, ambx1@neo.rr.com,
       linux-kernel@vger.kernel.org
Subject: Re: pnp_bus_resume(): inconsequent NULL checking
Message-ID: <20080221160907.GB28328@cs181133002.pp.htv.fi>
References: <20080219224908.GM31955@cs181133002.pp.htv.fi> <200802200959.21814.bjorn.helgaas@hp.com> <47BD1069.1060109@keyaccess.nl> <200802210826.53731.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200802210826.53731.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 08:26:53AM -0700, Bjorn Helgaas wrote:
> On Wednesday 20 February 2008 10:47:21 pm Rene Herman wrote:
> > On 20-02-08 17:59, Bjorn Helgaas wrote:
> > > I agree with you that we can just delete the dev->protocol tests
> > > completely. So I'd rather see something like this (built but untested):
> > >
> > >
> > > PNP: remove dev->protocol NULL checks
> > >
> > > Every PNP device should have a valid protocol pointer.  If it doesn't,
> > > something's wrong and we should oops so we can find and fix the problem.
> > >
> > > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> >
> > Ack from a functional standpoint: we are oopsing in pnp_start/stop_dev
> > _anyway_ if the protocol pointer isn't set.
> >
> > Will you coach this upstream? A 2.6.25-rc1 change from me made the coverity
> > checker pick up on it which might be considered enough of an excuse to call
> > it a regression and submit this as a fix...
> 
> I'll push it upstream, but a coverity warning seems like a marginal
> excuse for putting it in 2.6.25.  Is there any real reason it can't
> wait until 2.6.26?

The main purpose of my mail was to get an answer whether the NULL check 
should be removed or whether there's a NULL dereference that could 
happen in practice (which would have been a real bug).

A NULL check too much is not a real bug and therefore it can't count as 
a regression, so from my side it doesn't matter whether you push it as 
"trivial enough" for 2.6.25 or as "not urgent" for 2.6.26.

> > Rene.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

