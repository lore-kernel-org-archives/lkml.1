Return-Path: <linux-kernel-owner+w=401wt.eu-S1765391AbYEAVkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765391AbYEAVkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764365AbYEAVk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:40:26 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:38398 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763029AbYEAVkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:40:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=B88ra9PFCO4mPs+XYsSkDeXp4zZ2C1aB0VqoAS73JSusTZb1XxP5it+BxDZysWzm4DbKi9Em90xIN6aWj8A4zAj/3tZHFsBkIhXKpdXxi5cP3JWwUlYxegTyk9wzHxE+P2gs7xfNX9CAc/7LxAqa21ggkuzWheI9apwMT1+UhjU=  ;
X-YMail-OSG: XUTqjo8VM1lJlUKFJnyT.mmgB1G4f1AvKSBIYSiAycGLVb20JeOJfBCUiilLZfYKlpvpjZTgaDdIHZvb1DvRvwzPFL6RuV3RlxjNS7HQOJ3CdB8YyEOqjUf25LlG1KAqXCA-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [patch/rfc 2.6.25-git v2] gpio: sysfs interface
Date: Thu, 1 May 2008 14:40:17 -0700
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
References: <200804281239.51729.david-b@pacbell.net> <200804301434.25211.david-b@pacbell.net> <1209598093.3377.30.camel@moss.renham>
In-Reply-To: <1209598093.3377.30.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011440.18347.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 April 2008, Ben Nizette wrote:
> 
> On Wed, 2008-04-30 at 14:34 -0700, David Brownell wrote:
> > Simple sysfs interface for GPIOs.
> > 
> > /sys/class/gpio
> >     /control ... to request a GPIO be imported or returned
> >     /gpioN ... for each exported GPIO #N
> > 	    /value ... always readable, writes fail for input GPIOs
> > 	    /direction ... r/w as: in, out (default low); write high, low
> > 	/gpiochipN ... for each gpiochip; #N is its first GPIO
> > 	    /base ... (r/o) same as N
> > 	    /label ... (r/o) descriptive, not necessarily unique
> > 	    /ngpio ... (r/o) number of GPIOs; numbered N .. N+(ngpio - 1)
> 
> You dropped the 'device' symlink?  Sure it won't always be available but
> I did quite like the idea of being able to walk back through sysfs and
> discover, for example, the SPI chip select to which it's attached.

Just didn't describe it in that summary ... like several other
standard attributes, like "uevent" and "subsystem".  The only
thing different about "device" is that when the gpio_chip doesn't
say what device it uses, that will (necessarily) be missing.
And again, that's just like all other class device nodes.


> > +/*
> > + * /sys/class/gpio/control ... write-only
> > + *	integer N:  non-negative == export; negative == unexport
> > + */
> > +static ssize_t control_store(struct class *class, const char *buf, size_t len)
> 
> Unexport gpio 0?

Yeah, gotta fix that.  Unfortunately "-0" == "0" ... I'll have to
handle any leading "-" by hand.  Trivial fix, in all.

- Dave

