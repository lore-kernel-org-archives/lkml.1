Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbZGNIV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbZGNIV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 04:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZGNIV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 04:21:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:46376 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbZGNIVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 04:21:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=CbQrSSxh19Mbcrw28d89mLJ4QYlH3vr4T1UAv/NfxYUDKdZdQOcYp3BWgOnxVxIrV9
         BIHKNIoLD7ktkLwrHXAYzYtOLF4R7GYhtDhne5VUInr0n+O7rrJn3YQegSakKViTfPUQ
         fLPlAGjQPhZs+HOAYPbYv0+56yhBalZN6KNrc=
Date: Tue, 14 Jul 2009 01:21:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>,
       linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kwangwoo.lee@gmail.com, Trilok Soni <soni.trilok@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] tsc2007: remove HR timer
Message-ID: <20090714082151.GG2822@dtor-d630.eng.vmware.com>
References: <4A40C288.2060702@mocean-labs.com> <20090714044957.GD2822@dtor-d630.eng.vmware.com> <20090714070806.GA1619@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090714070806.GA1619@avionic-design.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 09:08:06AM +0200, Thierry Reding wrote:
> * Dmitry Torokhov wrote:
> > Hi Richard,
> > 
> > On Tue, Jun 23, 2009 at 01:54:48PM +0200, Richard Röjfors wrote:
> [...]
> > +static void tsc2007_free_irq(struct tsc2007 *ts)
> > +{
> > +	free_irq(ts->irq, ts);
> > +	if (cancel_delayed_work_sync(&ts->work)) {
> > +		/*
> > +		 * Work was pending, therefore we need to enable
> > +		 * IRQ here to balance the disable_irq() done in the
> > +		 * interrupt handler.
> > +		 */
> > +		enable_irq(ts->irq);
> > +	}
> > +}
> [...]
> > -static int tsc2007_remove(struct i2c_client *client)
> > +static int __devexit tsc2007_remove(struct i2c_client *client)
> >  {
> >  	struct tsc2007	*ts = i2c_get_clientdata(client);
> > -	struct tsc2007_platform_data *pdata;
> > +	struct tsc2007_platform_data *pdata = client->dev.platform_data;
> >  
> > -	cancel_delayed_work_sync(&ts->work);
> > +	free_irq(ts->irq, ts);
> > +	if (cancel_delayed_work_sync(&ts->work)) {
> > +		/*
> > +		 * Work was pending, therefore we need to enable
> > +		 * IRQ here to balance the disabel done in the
> > +		 * interrupt handler.
> > +		 */
> > +		enable_irq(ts->irq);
> > +	}
> 
> Shouldn't this be tsc2007_free_irq(ts) as well?
> 

Yep, it should, thanks.

-- 
Dmitry
