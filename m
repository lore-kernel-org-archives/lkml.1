Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113Ab0AYTja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0AYTja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 14:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394Ab0AYTj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 14:39:29 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:41749 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab0AYTj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 14:39:29 -0500
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jan 2010 14:39:28 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=aSsPW+xYlFW6metrxrfbtu9qNPBpZX74jP8Z+tuMjt5YiQHsXZdN5tLXgCbLgCbapG
         miBgF2T1ZlY8HzWvw3BXXVJz1XpumhAfGW1QR1IbvleBmgvwZKZV4PVI1VE4tKePJkS2
         17Qj5sH2gqdYTOlrst0VyKLLt1AtvzN+U98lY=
Date: Mon, 25 Jan 2010 11:31:08 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform_driver_register: warn if probe is in .init.text
Message-ID: <20100125193107.GC27387@core.coreip.homeip.net>
References: <20100122173846.GA11057@suse.de>
 <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20100122234936.GA14538@core.coreip.homeip.net>
 <20100123094916.GA24949@pengutronix.de>
 <20100125171439.GA27387@core.coreip.homeip.net>
 <20100125192540.GB14834@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100125192540.GB14834@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 08:25:40PM +0100, Uwe Kleine-König wrote:
> Hello Dmitry,
> 
> > > > > +	if (drv->probe && kernel_init_text_address((unsigned long)drv->probe))
> > > > > +		pr_warning("oops-warning: probe function of platform driver %s"
> > > > > +			       " lives in .init.text\n", drv->driver.name);
> > > > > +#else
> > > > > +	/*
> > > > > +	 * without HOTPLUG probe functions can be discarded after the driver is
> > > > > +	 * loaded.
> > > > > +	 * There is a little chance for false positives, namely if the driver is
> > > > > +	 * registered after the .init sections are discarded.
> > > > > +	 */
> > > > > +	if (drv->probe && !kernel_init_text_address((unsigned long)drv->probe))
> > > > > +		pr_info("probably the probe function of platform driver %s can"
> > > > > +				" be moved to .init.text\n", drv->driver.name);
> > > > 
> > > > It really depends on the user's (or rather builder's) local
> > > > configuration so how can we make this suggestion?
> > > Can you point out a situation that makes the suggestion wrong?  AFAIK
> > > there only the possibility that the driver is loaded after .init is
> > > discarded (as written in the comment).
> > > 
> > 
> > The presence of CONFIG_HOTPLUG depends on particular .config, so, for
> > example, you may not have it set while I have. So you will boot, get the
> > suggestion, submit a patch, then I will boot and will get a warning that
> > the probe function is in wrong section.
> > 
> > So in general I wonder if it is possible to request that all probe
> > functions are marked as __devinit or not marked at all, regardless of
> > CONFIG_HOTPLUG and CONFIG_MODULE settings.
> Would you agree if the message would change to
> 
> 	probably the probe function of platform driver %s can be moved
> 	to .devinit.text
> 
> ?

How about "Consider marking the probe function as '__devinit'"?

-- 
Dmitry
