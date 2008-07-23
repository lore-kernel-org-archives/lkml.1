Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYGWABr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYGWABr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 20:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYGWABj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 20:01:39 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:38329 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752444AbYGWABj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 20:01:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0EtSLcgvREexshCUwf+dBemYgH/Yc5lec2JhpPTpnDZ6EZAYt6Lf5WNvs3+vkVhWz44eejCeoID4uGeMCwqdJsIulbDkd7lSMEcRSaZ2lgRb+3cDY41qyfcBk1s1vTuwoFtX5tMz/ClnOBhw6RW6pwW7C4bf18rdf9BGWlj3Pek=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [patch 2.6.26-rc5] gpio: sysfs interface (updated)
Date: Tue, 22 Jul 2008 17:01:36 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       g.liakhovetski@pengutronix.de
References: <200806121153.36557.david-b@pacbell.net> <20080722162751.e8584d46.akpm@linux-foundation.org> <20080722232824.GA22596@kroah.com>
In-Reply-To: <20080722232824.GA22596@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807221701.36462.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008, Greg KH wrote:
> 
> > device_create_drvdata() has magically vanished from today's linux-next,
> > so this code doesn't compile any more.
> > 
> > This:
> > 
> > @@ -453,8 +453,8 @@ int gpio_export(unsigned gpio, bool dire
> >       if (status == 0) {
> >               struct device   *dev;
> >  
> > -             dev = device_create_drvdata(&gpio_class, desc->chip->dev, 0,
> > -                             desc, "gpio%d", gpio);
> > +             dev = device_create(&gpio_class, desc->chip->dev, 0, desc,
> > +                                     "gpio%d", gpio);
> 
> Should be NULL instead of 0 there, otherwise sparse will complain.

The zero is a dev_t ... ??  (As Andrew just noted too.)

"desc" might need to be NULL, but it's a valid pointer
(for driver_data).  I think this was a mental off-by-one...





