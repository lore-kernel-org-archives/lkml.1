Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZIBEiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZIBEiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 00:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZIBEiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 00:38:07 -0400
Received: from smtp106.sbc.mail.gq1.yahoo.com ([67.195.14.109]:34257 "HELO
	smtp106.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753984AbZIBEiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 00:38:06 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Sep 2009 00:38:06 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gDpwfM0w1LUlvei9TpgkvmzRq9J9cKIzI0TM1rFny3KQQVjf9p6BENwPUikqLafHgEsgif6libpD8ZiUpgYjE1a7ltCxjbQshSem+Gmfi3jtafYQcrBiHt23dEar/WWME2oqpAW64sI3l+aMFuiQ6A0NDtFfOvK51DoS/whtjBY=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: _mahPm8VM1lgH4V6dOfipuNn0l3kcOEBLX0kSI2c4PdOb4gxJq4r9R2w4fSSogZ6Yc9YD08z4VE9oBVP86C1QvGvW6Cbrqew_Zi.IJ4pM1I2ReRTWrQe_rsXeAQ0eeHsvtsGeyvaweVQmntUwIsye3_Jv_vCv7CkTabK6XsRAkxUJvXbaTnuxpjigYL5lDJQ0RQnWmWOzDU0iF0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.31-rc7] gpiolib: allow poll() on value
Date: Tue, 1 Sep 2009 18:04:10 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, dg@emlix.com
References: <200908271650.59287.david-b@pacbell.net> <20090901134311.95fba3c8.akpm@linux-foundation.org>
In-Reply-To: <20090901134311.95fba3c8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200909011804.10934.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 September 2009, Andrew Morton wrote:
> > ...
> >
> > +static struct idr pdesc_idr;
> 
> There's no locking to protect this tree.  If that isn't a bug then I'd
> suggest that a comment be added here explaining why.

Covered by mutex_lock(&sysfs_lock) calls per a quick re-read...


> > +static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
> > +{
> > +     struct work_struct      *work = priv;
> > +
> > +     schedule_work(work);
> > +     return IRQ_HANDLED;
> > +}
> 
> The only place where we explicitly cancel the pending work is in
> gpio_setup_irq().  Is that sufficient?  Is there any way in which the
> work callback can occur after things have been
> freed/closed/deinitialised/etc?

Not that I noticed; it's not supposed to be possible to
free/etc with IRQs active.

- Dave

