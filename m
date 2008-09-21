Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbYIUU2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbYIUU2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 16:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYIUU17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 16:27:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:59895 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbYIUU16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 16:27:58 -0400
Date: Sun, 21 Sep 2008 13:27:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, jgarzik@pobox.com, linville@tuxdriver.com,
       davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware
 restart.
Message-ID: <20080921132753.5689b564@infradead.org>
In-Reply-To: <20080921202057.GB25052@2ka.mipt.ru>
References: <20080921172316.GA6306@2ka.mipt.ru>
	<20080921110422.1d010b96@infradead.org>
	<20080921182835.GA11473@2ka.mipt.ru>
	<20080921113513.16677c4e@infradead.org>
	<20080921190050.GA20484@2ka.mipt.ru>
	<1222024444.3023.53.camel@johannes.berg>
	<20080921193809.GA8735@2ka.mipt.ru>
	<20080921124332.67ddc13a@infradead.org>
	<20080921202057.GB25052@2ka.mipt.ru>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 00:20:57 +0400
Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> On Sun, Sep 21, 2008 at 12:43:32PM -0700, Arjan van de Ven
> (arjan@infradead.org) wrote:
> > > @@ -3174,6 +3176,10 @@ static void ipw2100_irq_tasklet(struct
> > > ipw2100_priv *priv) if (inta & IPW2100_INTA_FATAL_ERROR) {
> > >  		printk(KERN_WARNING DRV_NAME
> > >  		       ": Fatal interrupt. Scheduling firmware
> > > restart.\n");
> > > +		WARN_ON(1);
> > > +
> > > +		BUG_ON(ipw2100_max_fatal_ints-- <= 0);
> > 
> > BUG_ON in interrupt context is just extremely hostile, since it
> > means the box is dead.
> >
> > also I would suggest using WARN_ON_ONCE() 
> 
> Well, I actually wanted to have a bug there because of it, but now I
> think that annoying repeated warning is enough to bring attention to
> the problem by putting bug information into some magic special place
> called kerneloops collection.

are you more interested in bringing attention than finding something
that makes the driver work ? I sort of am getting that impression and
I'd be disappointed if that is the case.


> 
> Consider for inclusing for the upcoming kernel to get wider
> notifications. Yes, it is not a bugfix, I know.

still more complex than needed; a WARN_ON_ONCE() will be enough.
